# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

. .\database\IDatabaseStrategy.ps1

class PostgresqlStrategy : IDatabaseStrategy {
    [PSCustomObject]$ConnectionString
    [string]$Version
    [string]$ScriptsFolder
    PostgresqlStrategy([PSCustomObject]$config) {
        $this.ConnectionString = $config.ConnectionString
        $this.ScriptsFolder = switch ($config.DataStandard){
            "Ds33"{ "$PSScriptRoot\postgresql\3.x"}
            "Ds4"{ "$PSScriptRoot\postgresql\4.x"}
            default { Write-Error "Data Standard is not valid";  exit 1;}
        }
       $this.Version = $config.DataStandard
    }

    [void]Run_DatabaseScript ([string]$script)
    {
        $server = $this.ConnectionString.Server
        $database = $this.ConnectionString.Database
        $username = $this.ConnectionString.Username
        $password = $this.ConnectionString.Password
        $port = $this.ConnectionString.Port
        $env:PGPASSWORD = $password
        if($port){
            psql -h $server -p $port -d $database -U $username -c $script
        }
        else{
            psql -h $server -d $database -U $username -c $script
        }
    }

    [string] Get_ArtifactsFolder() {
        return $this.ScriptsFolder
    }

    [string] Get_SchemaScript() {
        Write-Host "Creating Postgresql schema..."
        return "CREATE SCHEMA IF NOT EXISTS analytics;"
    }

    [string] Get_HistoryTableScript() {
        Write-Host "Creating Postgresql History table..."
        return "CREATE TABLE IF NOT EXISTS analytics.MigrationHistory ( ScriptName VARCHAR(255) PRIMARY KEY, AppliedOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
    }

    [string] Get_HistoryInsertScript($ScriptName) {
        Write-Host "PostgreSQL History: ${ScriptName}"
        return "INSERT INTO analytics.MigrationHistory (ScriptName) VALUES ('$ScriptName')"
    }
}

