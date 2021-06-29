# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# imports
$modulesPath = Join-Path -Path $PSScriptRoot -ChildPath "../modules"
$installerPath = Join-Path -Path $PSScriptRoot -ChildPath "../../EdFi.Suite3.Installer.WebApi"

Import-Module (Resolve-Path -Path (Join-Path -Path $modulesPath -ChildPath "config-helper.psm1")).Path
Import-Module (Resolve-Path -Path (Join-Path -Path $installerPath -ChildPath "Install-EdFiOdsWebApi.psm1")).Path

$config = Get-WebApiConfig

$parameters = @{
    PackageVersion   = $config["PackageVersion"]
    DbConnectionInfo = @{
        Engine                = "SqlServer"
        Server                = "localhost"
        UseIntegratedSecurity = $true
    }
    InstallType      = $config["InstallType"]
}

Write-Output "Installing ODS/API"

Write-Output @parameters

Set-Location $installerPath

Install-EdFiOdsWebApi @parameters
