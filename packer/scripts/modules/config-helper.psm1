# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

function Get-ApplicationConfig {
    Param (
        [string] $configPath = (Join-Path -Path $PSScriptRoot -ChildPath "../app-configuration.json")
    )

    $json = Get-Content -Path (Resolve-Path -Path $configPath ).Path | ConvertFrom-Json

    $config = @{}

    $json.psobject.properties | ForEach-Object { $config[$_.Name] = $_.Value }

    return $config
}

function  Get-WebApiConfig {
    $appConfig = Get-ApplicationConfig

    $config = @{}

    $appConfig["WebApi"].psobject.properties | ForEach-Object { $config[$_.Name] = $_.Value }

    return $config
}

function  Get-SwaggerUIConfig {
    $appConfig = Get-ApplicationConfig

    $config = @{}

    $appConfig["SwaggerUI"].psobject.properties | ForEach-Object { $config[$_.Name] = $_.Value }

    return $config
}

function  Get-AdminAppConfig {
    $configPath = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath "../app-configuration.json")).Path

    $appConfig = Get-ApplicationConfig -ConfigPath $configPath

    $config = @{}

    $appConfig["AdminApp"].psobject.properties | ForEach-Object { $config[$_.Name] = $_.Value }

    return $config
}

Export-ModuleMember -Function Get-WebApiConfig, Get-SwaggerUIConfig, Get-AdminAppConfig -Alias *
