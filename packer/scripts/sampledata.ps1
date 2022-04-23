# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

#requires -modules "path-resolver"

$url = "https://odsassets.blob.core.windows.net/public/TPDM/EdFi_Ods_Populated_Template_EPDM_Core_RW_v11_20220422.zip"

$databaseFolder = "$PSScriptRoot/../Database/"
if (-not (Test-Path $databaseFolder)) { New-Item -Path $databaseFolder -ItemType "Directory" | Out-Null }
$databaseFolder = Resolve-Path $databaseFolder

$fileName = $url.split('/')[-1]
$output = "$databaseFolder/$fileName"

# using WebClient is faster then Invoke-WebRequest but shows no progress
Write-host "Downloading sample data from $url..."
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $output)

if (-not (Test-Path $output)) { throw "Could not download sample data from $url to $output" }

Expand-Archive (Resolve-Path $output) -Destination $databaseFolder
Write-Host (Get-ChildItem "$databaseFolder/*.bak").FullName
return (Get-ChildItem "$databaseFolder/*.bak").FullName
