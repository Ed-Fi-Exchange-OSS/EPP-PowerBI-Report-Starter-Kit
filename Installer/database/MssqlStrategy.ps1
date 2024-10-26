# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

. .\database\IDatabaseStrategy.ps1

class MssqlStrategy : IDatabaseStrategy {
    [string]$ConnectionString
    [string]$Version
    [string]$ScriptsFolder

    MssqlStrategy([string]$connectionString, [string]$version) {
        $this.ConnectionString = $connectionString
        $this.ScriptsFolder = switch ($version){
            "3"{ "$PSScriptRoot\mssql\3.x"}
            "4"{ "$PSScriptRoot\mssql\4.x"}
        }
       $this.Version = $version
    }

    [void] Run_DatabaseScript ([string]$script)
    {
        $server = $this.ConnectionString.Server
        $database = $this.ConnectionString.Database
        $username = $this.ConnectionString.Username
        $password = $this.ConnectionString.Password
        # psql -S $server -d $database -U $username -P $password -i $scriptPath
    }

    [string] Get_ArtifactsFolder() {
        return $this.ScriptsFolder
    }

    [string] Get_SchemaScript() {
        Write-Host "Creating MSSQL schema..."
        return "IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'analytics')"
            + " BEGIN "
	        + " EXEC sp_executesql N'CREATE SCHEMA [analytics]';"
            +" END"
    }

    [string] Get_HistoryTableScript() {
        Write-Host "Creating MSSQL History table..."
        return "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='MigrationHistory' AND xtype='U')"
        +" CREATE TABLE analytics.MigrationHistory ("
        +"    ScriptName NVARCHAR(255) PRIMARY KEY,"
        +"    AppliedOn DATETIME DEFAULT GETDATE()"
        +")"
    }

    [string] Get_HistoryInsertScript($ScriptName) {
        Write-Host "Inserting MSSQL History: ${ScriptName}"
        return "INSERT INTO analytics.MigrationHistory (ScriptName) VALUES ('$ScriptName')"
    }
}
