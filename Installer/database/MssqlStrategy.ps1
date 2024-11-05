# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

. .\database\IDatabaseStrategy.ps1

class MssqlStrategy : IDatabaseStrategy {
    [PSCustomObject]$ConnectionString
    [string]$Version
    [string]$ScriptsFolder

    MssqlStrategy([PSCustomObject]$config) {
        $this.ConnectionString = $config.ConnectionString

        $this.ScriptsFolder = switch ($config.DataStandard){
            "Ds33"{ "$PSScriptRoot\ds-3.x\mssql"}
            "Ds4"{ "$PSScriptRoot\ds-4.x\mssql"}
            default { Write-Error "Data Standard is not valid";  exit 1;}
        }
       $this.Version = $config.DataStandard
    }

    [void] Run_DatabaseScript ([string]$script)
    {
        $server = $this.ConnectionString.Server
        $database = $this.ConnectionString.Database
        $username = $this.ConnectionString.Username
        $password = $this.ConnectionString.Password
        $port = $this.ConnectionString.Port
        $integratedSecurity = $this.ConnectionString.IntegratedSecurity

        $command = "sqlcmd -S $server"
        if($port){
            $command += ",$port";
        }
        $command += " -d $database"
        # Add authentication options
        if ($integratedSecurity) {
            $command += " -E"
        } else {
            $command += " -U $username -P $password"
        }
        $command += "-Q `"$script`""
        # Run the command
        Invoke-Expression $command
    }
    [void] Run_DatabaseScriptFile ([string]$scriptPath)
    {
        $server = $this.ConnectionString.Server
        $database = $this.ConnectionString.Database
        $username = $this.ConnectionString.Username
        $password = $this.ConnectionString.Password
        $port = $this.ConnectionString.Port
        $integratedSecurity = $this.ConnectionString.IntegratedSecurity

        $command = "sqlcmd -S $server"
        if($port){
            $command += ",$port";
        }
        $command += " -d $database"
        # Add authentication options
        if ($integratedSecurity) {
            $command += " -E"
        } else {
            $command += " -U $username -P $password"
        }
        $command += " -i `"$scriptPath`""
        # Run the command
        Invoke-Expression @"
            $command
"@
    }

    [string] Get_ArtifactsFolder() {
        return $this.ScriptsFolder
    }
}
