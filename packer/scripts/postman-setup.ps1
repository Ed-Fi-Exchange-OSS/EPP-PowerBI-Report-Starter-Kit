# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

Import-Module SqlServer
Invoke-SqlCmd -InputFile (Resolve-Path "C:/temp/scripts/postman-setup.sql").Path -Database "EdFi_Admin"
