# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

#Requires -Version 5
#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

$modulesPath = Join-Path -Path $PSScriptRoot -ChildPath "modules"
$fileHelper = (Resolve-Path (Join-Path -Path $modulesPath -ChildPath "file-helper.psm1")).Path

Import-Module $fileHelper

function Install-Choco {
    if (Get-Command "choco.exe" -ErrorAction SilentlyContinue) {
        Write-Output "Chocolatey is already installed. Setting choco command."
    }
    else {
        Write-Output "Installing Chocolatey..."
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        $ChocoCmd = Get-Command "choco.exe" -ErrorAction SilentlyContinue
        $ChocolateyInstall = Convert-Path "$($ChocoCmd.Path)\..\.."
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        RefreshEnv.cmd
        Update-SessionEnvironment
    }
    return Get-Command "choco.exe" -ErrorAction SilentlyContinue
}

function Enable-IisFeature {
    Param (
        [string] [Parameter(Mandatory = $true)] $featureName
    )

    $feature = Get-WindowsOptionalFeature -FeatureName $featureName -Online
    if (-not $feature -or $feature.State -ne "Enabled") {
        Write-Output "Enabling Windows feature: $($featureName)"

        $result = Enable-WindowsOptionalFeature -Online -FeatureName $featureName -NoRestart | Out-Null
        return $result.RestartNeeded
    }
    return $false
}

function Enable-RequiredIisFeatures {
    Write-Output "Installing IIS Features in Windows"

    $restartNeeded = Enable-IisFeature IIS-WebServerRole
    $restartNeeded += Enable-IisFeature IIS-WebServer
    $restartNeeded += Enable-IisFeature IIS-CommonHttpFeatures
    $restartNeeded += Enable-IisFeature IIS-HttpErrors
    $restartNeeded += Enable-IisFeature IIS-HttpRedirect
    $restartNeeded += Enable-IisFeature IIS-ApplicationDevelopment
    $restartNeeded += Enable-IisFeature IIS-HealthAndDiagnostics
    $restartNeeded += Enable-IisFeature IIS-HttpLogging
    $restartNeeded += Enable-IisFeature IIS-LoggingLibraries
    $restartNeeded += Enable-IisFeature IIS-RequestMonitor
    $restartNeeded += Enable-IisFeature IIS-HttpTracing
    $restartNeeded += Enable-IisFeature IIS-Security
    $restartNeeded += Enable-IisFeature IIS-RequestFiltering
    $restartNeeded += Enable-IisFeature IIS-Performance
    $restartNeeded += Enable-IisFeature IIS-WebServerManagementTools
    $restartNeeded += Enable-IisFeature IIS-IIS6ManagementCompatibility
    $restartNeeded += Enable-IisFeature IIS-Metabase
    $restartNeeded += Enable-IisFeature IIS-ManagementConsole
    $restartNeeded += Enable-IisFeature IIS-BasicAuthentication
    $restartNeeded += Enable-IisFeature IIS-WindowsAuthentication
    $restartNeeded += Enable-IisFeature IIS-StaticContent
    $restartNeeded += Enable-IisFeature IIS-DefaultDocument
    $restartNeeded += Enable-IisFeature IIS-WebSockets
    $restartNeeded += Enable-IisFeature IIS-ApplicationInit
    $restartNeeded += Enable-IisFeature IIS-ISAPIExtensions
    $restartNeeded += Enable-IisFeature IIS-ISAPIFilter
    $restartNeeded += Enable-IisFeature IIS-HttpCompressionStatic
    $restartNeeded += Enable-IisFeature NetFx4Extended-ASPNET45
    $restartNeeded += Enable-IisFeature IIS-NetFxExtensibility45
    $restartNeeded += Enable-IisFeature IIS-ASPNET45

    return $restartNeeded
}

function Install-IISUrlRewriteModule {
    Write-Output "Downloading IIS Rewrite Module 2"
    $url = "https://odsassets.blob.core.windows.net/public/installers/url_rewrite/rewrite_amd64_en-US.msi"
    $downloadedFile = Get-FileFromInternet $url

    $expectedHash = "90C5B7934F69FAA77DE946678747FFE4BD0E80647DF79C373C73FA3C5864F85C2DF1C3BD6B6B47A767D2E75493D2E986D2382769ABE9BEB143C5E196715AE6BF"
    Test-FileHash -FilePath $downloadedFile -ExpectedHashValue $expectedHash

    $logFile = "rewrite_amd64_install.log"
    $absoluteLogFile = join-path (resolve-path .) $logFile

    Write-Output "Installing IIS Rewrite Module 2"
    Write-Output "Appending to log file $absoluteLogFile"

    $command = "msiexec"
    $argumentList = "/i $downloadedFile /quiet /l*v+! $logFile"

    Write-Output "$command $argumentList"
    $msiExitCode = (Start-Process $command -ArgumentList $argumentList -PassThru -Wait).ExitCode

    if ($msiExitCode) {
        Write-Output "Installation of IIS Rewrite Module 2:"
        Write-Output "    msiexec returned status code $msiExitCode."
        Write-Output "    See $absoluteLogFile for details."
    }
    else {
        Write-Output "Installation of IIS Rewrite Module 2:"
        Write-Output "    msiexec returned status code $msiExitCode (normal)."
        Write-Output "    See $absoluteLogFile for details."
    }
}

function Install-IIS {
    param()

    $restartNeeded = Enable-RequiredIisFeatures

    if (Get-Command "AI_GetMsiProperty" -ErrorAction SilentlyContinue) {
        $explanation = "Because the Advanced Installer package is running and responsible for MSI"
        $explanation = $explanation + " prerequisites, skipping unnecessary invocation of IIS Rewrite Module MSI."
        Write-Output $explanation
    }
    else {
        Install-IISUrlRewriteModule
    }

    Write-Output "Prerequisites verified"

    return $restartNeeded
}

<#
.SYNOPSIS
    Configures a VM for Starter Kit Assessments by installing all prerequisites.
.DESCRIPTION
    Downloads Chocolatey. Installs Dot Net Framework 4.8, SQL Server 2019 and SSMS and google chrome
.EXAMPLE
    Install-PreReq
    Downloads Chocolatey
    Installs prerequisites
.NOTES
    This will install the prerequisites for the ODS/API/Admin applications.
#>

function Enable-LongFileNames {
    if (Test-Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem') {
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -name "LongPathsEnabled" -Value 1 -Verbose -Force
    }
}

function RemoveDesktopIcons{
    Remove-Item "C:\Users\*\Desktop\Visual Studio Code.lnk" -Force
    Remove-Item "C:\Users\*\Desktop\Google Chrome.lnk" -Force
    Remove-Item "C:\Users\*\Desktop\Postman.lnk" -Force
    Remove-Item "C:\Users\*\Desktop\LibreOffice*.lnk" -Force
}

function Install-PreRequisites() {

    Start-Transcript -Path ".\server-setup.log"

    Enable-LongFileNames
    Install-IIS
    Install-Choco

    choco feature disable --name showDownloadProgress --execution-timeout=$installTimeout
    choco install dotnetfx -y --ignore-pending-reboot --execution-timeout=$installTimeout
    choco install vscode -y --ignore-pending-reboot --execution-timeout=$installTimeout
    choco install dotnetcore-sdk -y --ignore-pending-reboot --execution-timeout=$installTimeout
    choco install dotnetcore-windowshosting -y --ignore-pending-reboot --execution-timeout=$installTimeout
    choco install GoogleChrome -y --ignore-pending-reboot --ignore-checksums --execution-timeout=$installTimeout
    choco install sql-server-express -y -o -ia "'/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER /TCPENABLED=1 /UPDATEENABLED=FALSE'" --execution-timeout=$installTimeout
    choco install sql-server-management-studio -y --ignore-pending-reboot --execution-timeout=$installTimeout
    choco install postman -y --ignore-pending-reboot --execution-timeout=$installTimeout
    choco install libreoffice-fresh -y --ignore-pending-reboot --execution-timeout=$installTimeout

    Install-Module -Name SqlServer -MinimumVersion '21.1.18068' -Scope CurrentUser -Force -AllowClobber

    RemoveDesktopIcons
    
    Stop-Transcript
}

function Set-WallPaper {
    Write-Output "Downloading wallpaper image"

    if (-not (Test-path "C:/Ed-Fi-Starter-Kit/")) {
        New-Item -Path "C:/Ed-Fi-Starter-Kit/" -ItemType "directory"
    }

    $url = "https://edfidata.s3-us-west-2.amazonaws.com/Starter+Kits/images/EdFiQuickStartBackground.png"
    Invoke-WebRequest -Uri $url -OutFile "C:/Ed-Fi-Starter-Kit/EdFiQuickStartBackground.png"
	
    Set-ItemProperty -path "HKCU:\Control Panel\Desktop" -name WallPaper -value "C:/Ed-Fi-Starter-Kit/EdFiQuickStartBackground.png"
    Set-ItemProperty -path "HKCU:\Control Panel\Desktop" -name WallpaperStyle -value "0" -Force
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}

Set-TLS12Support
Set-ExecutionPolicy bypass -Scope CurrentUser -Force;

Set-WallPaper
Install-PreRequisites
