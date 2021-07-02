# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# imports
$modulesPath = Join-Path -Path $PSScriptRoot -ChildPath "../modules"
$installerPath = Join-Path -Path $PSScriptRoot -ChildPath "../../EdFi.Suite3.Installer.SwaggerUI"

Import-Module (Resolve-Path -Path (Join-Path -Path $modulesPath -ChildPath "config-helper.psm1")).Path -Force
Import-Module (Resolve-Path -Path (Join-Path -Path $installerPath -ChildPath "Install-EdFiOdsSwaggerUI.psm1")).Path

# script logic
$config = Get-SwaggerUIConfig

$parameters = @{
    PackageVersion   = $config["PackageVersion"]
    WebApiVersionUrl = ($config["WebApiVersionUrl"] -f [Environment]::MachineName)
    PrePopulatedKey = "starterKit"
    PrePopulatedSecret = "starterKitSecret"
}

Write-Output "Installing SwaggerUI"

Write-Output @parameters

Set-Location $installerPath

Install-EdFiOdsSwaggerUI @parameters
