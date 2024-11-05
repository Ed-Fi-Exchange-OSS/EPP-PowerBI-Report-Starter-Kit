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
            "Ds33"{ "$PSScriptRoot\ds-3.x\postgresql"}
            "Ds4"{ "$PSScriptRoot\ds-4.x\postgresql"}
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
        $integratedSecurity = $this.ConnectionString.IntegratedSecurity

        $command = "psql -h $server"
        if($port){
            $command += " -p $port"
        }
        $command += " -d $database "
        # Add authentication options
        if ($integratedSecurity) {
            $command += " -w"
        } else {
            $command += " -U $username"
            # Set the PGPASSWORD environment variable for password authentication
            $env:PGPASSWORD = $password
        }
        $command += " -c `"$script`""
        Invoke-Expression $command
        # Clear the PGPASSWORD environment variable
        if (-not $integratedSecurity) {
            Remove-Item Env:PGPASSWORD
        }
    }

    [void]Run_DatabaseScriptFile ([string]$scriptPath)
    {
        $server = $this.ConnectionString.Server
        $database = $this.ConnectionString.Database
        $username = $this.ConnectionString.Username
        $password = $this.ConnectionString.Password
        $port = $this.ConnectionString.Port
        $integratedSecurity = $this.ConnectionString.IntegratedSecurity

        $command = "psql -h $server --quiet "
        if($port){
            $command += " -p $port"
        }
        $command += " -d $database "
        # Add authentication options
        if ($integratedSecurity) {
            $command += " -w"
        } else {
            $command += " -U $username"
            # Set the PGPASSWORD environment variable for password authentication
            $env:PGPASSWORD = $password
        }
        $command += " -f `"$scriptPath`""
        Invoke-Expression $command
        # Clear the PGPASSWORD environment variable
        if (-not $integratedSecurity) {
            Remove-Item Env:PGPASSWORD
        }
    }

    [string] Get_ArtifactsFolder() {
        return $this.ScriptsFolder
    }
}

