# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

function Invoke-ValidateDriveSpace {
    param ([int] $MinimumSpace)

    $drive = ((Get-Location).Path.Split(":")).Get(0)

    $spaceAvailable = (Get-Volume -DriveLetter $drive).SizeRemaining / 1GB

    if ($spaceAvailable -lt $MinimumSpace) { throw "Not enough space to build the VM. {0} GB is required." -f $MinimumSpace }
}

function Invoke-CreateVMSwitch {
    param ($VMSwitch)

    # Get the first physical network adapter that has an Up status.
    $net_adapter = ((Get-NetAdapter -Name "*" -Physical) | Where-Object { $_.Status -eq 'Up' })[0].Name

    Write-Output "Checking for existence of VM Switch $($VMSwitch)"

    # Note this requires admin privileges
    if ($null -eq (Get-VMSwitch -Name $VMSwitch -ErrorAction SilentlyContinue)) {
        Write-Output "Creating new VM Switch $($VMSwitch)"
        New-VMSwitch -Name $VMSwitch -AllowManagementOS $true -NetAdapterName $net_adapter -MinimumBandwidthMode Weight
    }
}

function Invoke-PackageDownloads {
    param (
        [string] [Parameter(Mandatory = $true)] $ConfigPathPath,
        [string] [Parameter(Mandatory = $true)] $BuildPath
    )

    $ConfigPath = Get-Content $ConfigPathPath | ConvertFrom-Json

    $url_template = $ConfigPath.url_template

    $components = @{}
    $ConfigPath.components.psobject.properties | ForEach-Object { $components[$_.Name] = $_.Value }

    foreach ($key in $components.Keys) {
        $version = $components[$key].version
        $package_name = $components[$key].package_name

        $fullName = (Join-Path -Path $BuildPath -ChildPath ( "{0}.zip" -f $package_name ))
        $url = $url_template -f $package_name, $version

        # ignore if already downloaded
        if ((Test-Path -Path $fullName)) {
            Write-Output ("Skipping '{1}' package version '{2}' download of '{0}'" -f $fullName, $package_name, $version)
        }
        else {
            Write-Output ("Downloading '{1}' package version '{2}' to '{0}'" -f $fullName, $package_name, $version)
            Invoke-WebRequest -Uri $url -OutFile $fullName
        }
    }
}

function Set-EnvironmentVariables {
    param(
        [string] [Parameter(Mandatory = $true)] $LogsPath,
        [string] [Parameter(Mandatory = $true)] $BuildPath
    )

    Set-Item -Path Env:PACKER_LOG -Value 1
    Set-Item -Path Env:PACKER_LOG_PATH -Value (Join-Path -Path (Resolve-Path -Path $LogsPath).Path -ChildPath "packer.log")
    Set-Item -Path Env:PACKER_CACHE_DIR -Value (Join-Path -Path (Resolve-Path -Path $BuildPath).Path -ChildPath "packer_cache")
}

function Invoke-Packer {
    param (
        [string] [Parameter(Mandatory = $true)] $ConfigPath,
        [string] [Parameter(Mandatory = $true)] $VariablesPath,
        [string] $VMSwitch = "packer-hyperv-iso",
        [string] $ISOUrl = $null
    )

    #initialize packer and its packages
    & packer init $ConfigPath

    if ( -not $ISOUrl) {
        & packer build -force -var "vm_switch=$($VMSwitch)" "-var-file=$($VariablesPath)" $ConfigPath
    }
    else {
        & packer build -force -var "vm_switch=$($VMSwitch)" -var "iso_url=$($ISOUrl)" "-var-file=$($VariablesPath)" $ConfigPath
    }
}

Export-ModuleMember -Function Invoke-ValidateDriveSpace, Invoke-CreateVMSwitch, Invoke-PackageDownloads, Set-EnvironmentVariables, Invoke-Packer -Alias *
