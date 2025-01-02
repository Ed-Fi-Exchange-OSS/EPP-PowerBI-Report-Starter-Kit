# EPP Power BI Report Starter Kit

The Educator Preparation Program (EPP) Power BI Report Starter Kit repository is meant to be used in conjunction with the [Program Diversity and Persistence Starter Kit](https://techdocs.ed-fi.org/display/SK/Program+Diversity+and+Persistence+Starter+Kit) and the [Clinical Experience and Performance Starter Kit](https://techdocs.ed-fi.org/display/SK/Clinical+Experience+and+Performance+Starter+Kit) pages in [Ed-Fi Tech Docs](https://techdocs.ed-fi.org/)

The EPP Power BI Starter Kit focuses on two use cases and allows EPPs to understand how TPDM data can be modeled and visualized in Power BI.

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
