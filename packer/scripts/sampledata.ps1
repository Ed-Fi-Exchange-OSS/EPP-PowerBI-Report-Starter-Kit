# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

#requires -modules "path-resolver"


$packagePath  = Join-Path -Path $PSScriptRoot -ChildPath "../../../../EdFi_Populated_Template_TPDM_RW"
return Get-ChildItem "$packagePath/*.bak"
