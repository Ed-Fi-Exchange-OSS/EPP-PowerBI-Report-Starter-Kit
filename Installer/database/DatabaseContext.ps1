# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

. .\database\IDatabaseStrategy.ps1
. .\database\MssqlStrategy.ps1
. .\database\PostgresqlStrategy.ps1

class DatabaseContext {
    [IDatabaseStrategy]$DatabaseStrategy

    DatabaseContext([IDatabaseStrategy]$strategy) {
        $this.DatabaseStrategy = $strategy
    }

    [void] Start_DatabaseScript() {
        Write-Host "Initialize Database..."
        $schema = $this.DatabaseStrategy.Get_SchemaScript()
        $history = $this.DatabaseStrategy.Get_HistoryTableScript()
        $this.DatabaseStrategy.Run_DatabaseScript($schema)
        $this.DatabaseStrategy.Run_DatabaseScript($history)
        $folder = $this.DatabaseStrategy.Get_ArtifactsFolder()
        write-host "DDD $folder"
        $files = Get-ChildItem -Recurse -Path $folder -Filter "*.sql"
        foreach ($file in $files) {
            $relativePath = $file | Resolve-Path -Relative
            Write-Host "Running script $relativePath"
            #$script = Get-Content -Path $file.FullName -Raw
            $this.DatabaseStrategy.Run_DatabaseScriptFile($file.FullName)
        }
    }
}
