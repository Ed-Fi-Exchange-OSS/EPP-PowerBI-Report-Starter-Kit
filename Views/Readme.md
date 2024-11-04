# EPP Power BI Report Starter Kit - Views

## Requirements

In order to run the EPP Power BI reports, EPP specific views need to be installed on the Ed-Fi ODS.  These instructions assume that you have already installed the Ed-Fi ODS and if you are using PostgreSQL, you can locate the PostgreSQL binary files (psql.exe) used to execute SQL commands against the database.

## Installation

### Summary

Two scripts are available depending on the database used to host the Ed-Fi ODS:  

For SQL Server:  

- InstallEPPPowerBIStarterKitMSSQLViews.ps1 file

For PostgreSQL:  

- InstallEPPPowerBIStarterKitPostgreSQLViews.ps1

### Preparation

**Before installation, be sure to review and, if necessary, edit the PowerShell script that applies to your installation**  
Properties that may need to be modified include:  

- Views Folder path (if not running script from the EPP-PowerBI-Report-Starter-Kit directory)
- Data Standard Folder (corresponds to the data standard you wish to use)
- Server
- Database
- Username (if not using trusted connection)
- Password (if not using trusted connection)
- PathToPostgreSQLBinaries (for PostgreSQL)

### Execution and validation

Execute the applicable Powershell Script and verify that the views have been added to the ODS  

## Legal Information

Copyright (c) 2020 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
