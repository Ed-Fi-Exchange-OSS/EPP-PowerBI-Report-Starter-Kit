# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

param (
   [string]$ConfigFile = ".\config.json"
)
Import-Module "$PSScriptRoot\DatabaseScripts.psm1"  -Force
$validValues = @("Ds33", "Ds4")
$engineValidValues = @("mssql", "postgresql")

$config = Get-Content -Raw -Path $ConfigFile | ConvertFrom-Json
$DataStandardParam = $null
$EngineParam = $null

# Check if the parameter is provided via command line or config file
if (-not $DataStandardParam -and $config) {
    # Read configuration from JSON file
    $DataStandardParam = $config.DataStandard
}
if (-not $EngineParam -and $config) {
    # Read configuration from JSON file
    $EngineParam = $config.DatabaseEngine
}
if ((-not $DataStandardParam -or -not $EngineParam) -or $validValues -notcontains $DataStandardParam -or $engineValidValues -notcontains $EngineParam) {
    Write-Output "Usage: .\install.ps1 -ConfigFile <path>"
    Write-Output "Valid values for DataStandard are: $($validValues -join ', ')"
    Write-Output "Valid values for DatabaseEngine are: $($engineValidValues -join ', ')"
    exit 1
}
else{
    # Run the scripts
    Start-DatabaseInstallation -config $config
}
