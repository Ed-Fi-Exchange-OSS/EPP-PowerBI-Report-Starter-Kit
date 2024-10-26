# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

param (
    [string]$ConfigFilePath = ".\config.json"
	#[ValidateSet("install", "update", "uninstall")]
)
Import-Module "$PSScriptRoot\DatabaseScripts.psm1"  -Force

# Read configuration from JSON file
$config = Get-Content -Raw -Path $ConfigFilePath | ConvertFrom-Json

# Run the scripts
Start-DatabaseInstallation -config @config
