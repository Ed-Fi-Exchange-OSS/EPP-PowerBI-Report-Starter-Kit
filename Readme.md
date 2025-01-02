# EPP Power BI Report Starter Kit

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/Ed-Fi-Exchange-OSS/EPP-PowerBI-Report-Starter-Kit/badge)](https://securityscorecards.dev/viewer/?uri=github.com/Ed-Fi-Exchange-OSS/EPP-PowerBI-Report-Starter-Kit)

The Educator Preparation Program (EPP) Power BI Report Starter Kit repository is meant to be used in conjunction with the Program Diversity and Persistence and Clinical Experience and Performance [use cases](https://docs.ed-fi.org/getting-started/educator-pipeline) for Educator Pipeline programs.

The EPP Power BI Starter Kit focuses on two use cases and allows EPPs to understand how EPDM data can be modeled and visualized in Power BI.

## Prerequisites

* Power BI Desktop
* EPP Views

### Database views installation

To ensure your Power BI report functions correctly, you must first install the necessary [database views](./Views/). There are separate PowerShell installation scripts for [Microsoft SQL Server](./Views/InstallEPPPowerBIStarterKitMSSQLViews.ps1) and [PostgreSQL](./Views/InstallEPPPowerBIStarterKitPostgreSQLViews.ps1). Open the desired file and edit the relevant connection variables at the top before executing.

## Legal Information

Copyright (c) 2024 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
