$pathToPostgreSQLBinaries = "C:\Program Files\PostgreSQL\14\bin\psql.exe"
# Example of a tools directory containing psql.exe after running `initdev` from the ODS/API source code
# $pathToPostgreSQLBinaries = "D:\ed-fi\Ed-Fi-ODS-Implementation\tools\PostgreSQL.Binaries.16.3.112\tools\psql.exe"


# Folder path to the views directory
$viewsFolderPath = "./"
$dataStandardFolder = "ds-4.0"
# Relative path that corresponds to the folder containing the scripts for your needed data standard
$baseFolder = "Base/PostgreSQL"
$rlsFolder = "RLS/PostgreSQL"
$eppFolder = "EPP/PostgreSQL"

# Database parameters
$port = 5402
$server = "localhost"
$database = "EdFi_Ods"
$username = "postgres"
# Leave password blank if using a pgpass file
$env:PGPASSWORD = "Good,Pwd2024"

$env:PGCLIENTENCODING = "utf-8"

function Invoke-PsqlFile {
    Param (

        [string] [Parameter(Mandatory = $true)] $serverName,

        [string] [Parameter(Mandatory = $true)] $portNumber,

        [string] $userName,

        [string] [Parameter(Mandatory = $true)] $databaseName,

        [string] [Parameter(Mandatory = $true)] $filePath
    )

    $params = @(
        "--echo-errors",
        "--quiet",
        "--no-password",
        "--host", $serverName,
        "--port", $portNumber,
        "--dbname", $databaseName,
        "--file", $filePath
    )

    if ($userName) { $params += @("--username", $userName) }

    $psql = $pathToPostgreSQLBinaries
    Write-Host -ForegroundColor Magenta "& $psql $params"
    & $psql $params

    if ($LASTEXITCODE -ne 0) {
        throw "Unable to complete install: please review and correct the error described above."
    }
}


$dataStandardFolderPath = Join-Path -Path $viewsFolderPath -ChildPath $dataStandardFolder
$baseFolderPath = Join-Path -Path $dataStandardFolderPath -ChildPath $baseFolder
$rlsFolderPath = Join-Path -Path $dataStandardFolderPath -ChildPath $rlsFolder
$eppFolderPath = Join-Path -Path $dataStandardFolderPath -ChildPath $eppFolder

$files = Get-ChildItem -Path $baseFolderPath

# Iterate through each file in the data standard folder that you wish to use
foreach ($file in $files)
{
    WRITE-HOST $file.FullName
    Invoke-PsqlFile -filePath $file.FullName -serverName $server -portNumber $port -username $username -databaseName $database
}

$files = Get-ChildItem -Path $rlsFolderPath
# Iterate through each file in the data standard folder that you wish to use
foreach ($file in $files)
{
    WRITE-HOST $file.FullName
    Invoke-PsqlFile -filePath $file.FullName -serverName $server -portNumber $port -username $username -databaseName $database
}

$files = Get-ChildItem -Path $eppFolderPath
# Iterate through each file in the data standard folder that you wish to use
foreach ($file in $files)
{
    WRITE-HOST $file.FullName
   Invoke-PsqlFile -filePath $file.FullName -serverName $server -portNumber $port -username $username -databaseName $database
}


