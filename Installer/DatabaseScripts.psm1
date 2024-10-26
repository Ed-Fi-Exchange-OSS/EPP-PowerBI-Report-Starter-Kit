# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Import the module
. "$PSScriptRoot\database\IDatabaseStrategy.ps1"  -Force
. "$PSScriptRoot\database\MssqlStrategy.ps1"  -Force
. "$PSScriptRoot\database\PostgresqlStrategy.ps1"  -Force
. "$PSScriptRoot\database\DatabaseContext.ps1"  -Force

function Start-DatabaseInstallation {
    param (
        [PSCustomObject]$config
    )
    # Initialize the appropriate strategy based on config
    $strategy = switch ($config.DatabaseEngine.ToLower()) {
        "mssql" { [MssqlStrategy]::new($config.ConnectionString, $config.DatabaseStandardVersion) }
        "postgresql" { [PostgresqlStrategy]::new($config.ConnectionString, $config.DatabaseStandardVersion) }
        default { throw "Unsupported database engine: $($config.DatabaseEngine)" }
    }
    $context = [DatabaseContext]::new($strategy)
    $context.Start_DatabaseScript()
}
