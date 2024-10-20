# Folder path to the views directory
$viewsFolderPath = "./"
$dataStandardFolder = "ds-4.0"
# Relative path that corresponds to the folder containing the scripts for your needed data standard
$baseFolder = "Base/MSSQL"
$RLSFolder = "RLS/MSSQL"
$EPPFolder = "EPP/MSSQL"

# SQL Server and database
$server = "."
$database = "EdFi_ODS"
# SQL Server username and password (if not using trusted connection)
$username = ""
$password = ""

# Uncomment the connection string that you wish to use
$connectionString = "server=$server;trusted_connection=True;database=$database;"
# $connectionString = "server=$server;user id=$username; password=$password;database=$database;"

$baseFolderPath = Join-Path -Path $viewsFolderPath -ChildPath $baseFolder 
$standardFolderPath = Join-Path -Path $viewsFolderPath -ChildPath $dataStandardFolder
 
$files = Get-ChildItem -Path $baseFolderPath

# Iterate through each file in the data standard folder that you wish to use
foreach ($file in $files) {
    
    Invoke-Sqlcmd -InputFile $file.FullName -ConnectionString $connectionString
}

$files = Get-ChildItem -Path $standardFolderPath
# Iterate through each file in the data standard folder that you wish to use
foreach ($file in $files) {
    
    Invoke-Sqlcmd -InputFile $file.FullName -ConnectionString $connectionString
}