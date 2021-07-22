# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

<#
.SYNOPSIS
    This builds a Starter Kit virtual machine using Packer
.DESCRIPTION
    Configures Packer logging, Defines a network adapter and vm switch,
    compresses assessment PowerShell scripts, and intitiates the packer build.
.EXAMPLE
    PS C:\> .\build-vm.ps1
    Creates a virtual machine image that can be imported using the Hyper-V Manager
.NOTES
    Sets the Packer debug mode and logging path variables at runtime.
#>

param(
    [string] [Parameter(Mandatory = $true)] $PackerFile,
    [string] [Parameter(Mandatory = $true)] $VariablesFile,
    [string] $VMSwitch = "packer-hyperv-iso",
    [string] $ISOUrl = $null,
    [switch] $SkipCreateVMSwitch = $false,
    [switch] $SkipRunPacker = $false,
    [switch] $DownloadBaseImage = $false
)

#Requires -RunAsAdministrator
#Requires -Version 5

#imports
$modulesPath = Join-Path -Path $PSScriptRoot -ChildPath "scripts/modules"
Import-Module (Resolve-Path -Path (Join-Path -Path $modulesPath -ChildPath "file-helper.psm1")).Path
Import-Module (Resolve-Path -Path (Join-Path -Path $modulesPath -ChildPath "packer-helper.psm1")).Path -Force

#global vars
$buildPath = Join-Path -Path $PSScriptRoot -ChildPath "build"
$logsPath = Join-Path -Path $buildPath -ChildPath "logs"
$configPath = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath "build-configuration.json")).Path

function Invoke-CreateFolders {
    New-Item -ItemType Directory -Path $buildPath -Force | Out-Null
    New-Item -ItemType Directory -Path $logsPath -force | Out-Null
}

# Validate we have enough disk space
Invoke-ValidateDriveSpace -MinimumSpace 30

# Enable Tls2 support
Set-TLS12Support

# Create Build and Distribution Folders
Invoke-CreateFolders

# Download base image from S3 only for Starter Kit build
$fileName = Split-Path $PackerFile -leaf
if ($DownloadBaseImage -and ($fileName -eq "epp-starter-kit-win2019-eval.pkr.hcl")) {

    if (Test-Path "downloads/BaseQuickStartVM-Current.zip") {
        Write-Output "Deleting old file"
        Remove-Item -Path "downloads/BaseQuickStartVM-Current.zip" -Force
    }

    Write-Output "Downloading base image from S3"
    $url = "https://edfi-starter-kits.s3-us-east-2.amazonaws.com/BaseQuickStartVM/BaseQuickStartVM-Current.zip"
    $downloadedFile = Get-FileFromInternet $url

    if (-not (Get-InstalledModule | Where-Object -Property Name -eq "7Zip4Powershell")) {
        Install-Module -Force -Scope CurrentUser -Name 7Zip4Powershell
    }

    Expand-7Zip -ArchiveFileName $downloadedFile -TargetPath $buildPath
}

#download packages and push to to build folder
Invoke-PackageDownloads -ConfigPath $configPath -BuildPath $buildPath

# Compress PowerShell to a zip archive
Compress-Archive -Path (Join-Path -Path $PSScriptRoot -ChildPath "scripts/*") -Destination  (Join-Path -Path $buildPath -ChildPath "scripts.zip") -Force

# Compress PowerBI files to a zip archive
Compress-Archive -Path (Join-Path -Path $PSScriptRoot -ChildPath "../Clinical Experience/*.pbix") -Destination  (Join-Path -Path $buildPath -ChildPath "Clinical Experience.zip") -Force

Compress-Archive -Path (Join-Path -Path $PSScriptRoot -ChildPath "../EPP Diversity and Completion/*.pbix") -Destination  (Join-Path -Path $buildPath -ChildPath "EPP Diversity and Completion.zip") -Force

# Compress landing page and resources to a zip archive
Compress-Archive -Path (Join-Path -Path $PSScriptRoot -ChildPath "docs") -Destination  (Join-Path -Path $buildPath -ChildPath "docs.zip") -Force

# Configure runtime environment vars
Set-EnvironmentVariables -BuildPath $buildPath -LogsPath $logsPath

# Configure VMSwitch
if (-not ($SkipCreateVMSwitch)) { Invoke-CreateVMSwitch -VMSwitch $VMSwitch}
else { Write-Output "Skipping VM Switch validation and creation." }

# Kick off the packer build with the force to override prior builds
if (-not ($SkipRunPacker)) {
    $packerConfig = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath $PackerFile)).Path
    $packerVariables = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath $VariablesFile)).Path

    Invoke-Packer -ConfigPath $packerConfig -VariablesPath $packerVariables -VMSwitch $VMSwitch
}
else { Write-Output "Skipping Packer Execution" }
