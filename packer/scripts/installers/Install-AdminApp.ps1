# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# imports
$modulesPath = Join-Path -Path $PSScriptRoot -ChildPath "../modules"
$installerPath = Join-Path -Path $PSScriptRoot -ChildPath "../../EdFi.Suite3.Installer.AdminApp"

Import-Module (Resolve-Path -Path (Join-Path -Path $modulesPath -ChildPath "config-helper.psm1")).Path
Import-Module (Resolve-Path -Path (Join-Path -Path $installerPath -ChildPath "Install-EdFiOdsAdminApp.psm1")).Path -Force

$config = Get-AdminAppConfig

$dbConnectionInfo = @{
    Server                = "localhost"
    Engine                = "SqlServer"
    UseIntegratedSecurity = $true
}

$adminAppFeatures = @{
    ApiMode = $config["ApiMode"]
}

$parameters =
@{
    ToolsPath        = $config["ToolsPath"]
    DbConnectionInfo = $dbConnectionInfo
    OdsApiUrl        = ($config["OdsApiUrl"] -f [Environment]::MachineName)
    PackageVersion   = $config["PackageVersion"]
    AdminAppFeatures = $adminAppFeatures
}


Write-Output "Installing AdminApp"

Write-Output @parameters

Set-Location $installerPath

Install-EdFiOdsAdminApp @parameters
