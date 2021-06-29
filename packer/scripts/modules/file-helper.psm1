# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

function Set-TLS12Support {
    if (-not [Net.ServicePointManager]::SecurityProtocol.HasFlag([Net.SecurityProtocolType]::Tls12)) {
        [Net.ServicePointManager]::SecurityProtocol += [Net.SecurityProtocolType]::Tls12
    }
}

function Get-FileFromInternet {
    param (
        [string] [Parameter(Mandatory = $true)] $url
    )

    New-Item -Force -ItemType Directory "downloads" | Out-Null

    $fileName = $url.split('/')[-1]
    $output = "downloads\$fileName"

    if (Test-Path $output) {
        # File already exists, don't attempt to re-download
        return $output
    }

    Invoke-WebRequest -Uri $url -OutFile $output

    return $output
}

function Test-FileHash {
    param(
        [string] [Parameter(Mandatory = $true)] $ExpectedHashValue,
        [string] [Parameter(Mandatory = $true)] $FilePath
    )

    $calculated = (Get-FileHash $FilePath -Algorithm SHA512).Hash

    if ($ExpectedHashValue -ne $calculated) {
        throw "Aborting install: cannot be sure of the integrity of the downloaded file " +
        "$FilePath. Please contact techsupport@ed-fi.org or create a " +
        "bug report at https://tracker.ed-fi.org"
    }
}

Export-ModuleMember -Function Test-FileHash, Get-FileFromInternet, Set-TLS12Support -Alias *
