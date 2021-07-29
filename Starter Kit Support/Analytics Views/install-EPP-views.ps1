# if executing this script from the different folder as the views remove the # from the line below and update the path to the folder with the views
$pathToViews # = "c:\temp\EPP-PowerBI-Report-Starter-Kit\Starter Kit Support\Analytics Views"
# update the connection string to match your SQL server
$connectionString = "Data Source=.\SQL2017;Initial Catalog=EdFi_Ods;Integrated Security=True"

Try {
    Write-Output "Creating Schema: Analytics"
    Invoke-Sqlcmd -ConnectionString $connectionString -InputFile "Schema-Analytics-Create.sql"

    Write-Output $pathToViews
    if($null -eq $pathToViews) {
        $pathToViews = $PSScriptRoot
    }

    $files = Get-ChildItem $pathToViews

     foreach ($f in $files){
         if (!$f.Name.Contains("Schema-Analytics-Create") -and $f.Name.Contains(".sql")) {
             Write-Output "Installing view $f"
             Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $f.Name
         }
     }
     Write-Output "Views installed successfully"
}
catch {}
