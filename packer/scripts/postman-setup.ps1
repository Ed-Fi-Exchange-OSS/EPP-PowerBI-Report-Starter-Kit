# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

function Set-PostmanEnvironmentConfig {
    $configPath = (Resolve-Path "C:/Ed-Fi-Starter-Kit/Postman/SEA Modernization Starter Kit Environment (Local).postman_environment.json").Path

    $config = Get-Content $configPath | ConvertFrom-Json

    $apiBaseUrl = $config.values | Where-Object { $_.key -eq 'ApiBaseUrl' }

    $apiBaseUrl.value = ($apiBaseUrl.value -f [Environment]::MachineName)

    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -NoNewline -Encoding UTF8

    return $config
}

Set-PostmanEnvironmentConfig

Import-Module SqlServer
Invoke-SqlCmd -InputFile (Resolve-Path "C:/temp/scripts/postman-setup.sql").Path -Database "EdFi_Admin"
