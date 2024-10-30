# EPP Power BI Report Starter Kit

The Educator Preparation Program (EPP) Power BI Report Starter Kit repository is meant to be used in conjunction with the [Program Diversity and Persistence Starter Kit](https://techdocs.ed-fi.org/display/SK/Program+Diversity+and+Persistence+Starter+Kit) and the [Clinical Experience and Performance Starter Kit](https://techdocs.ed-fi.org/display/SK/Clinical+Experience+and+Performance+Starter+Kit) pages in [Ed-Fi Tech Docs](https://techdocs.ed-fi.org/)

The EPP Power BI Starter Kit focuses on two use cases and allows EPPs to understand how TPDM data can be modeled and visualized in Power BI.

## Prerequisites
* Power BI Desktop
* EPP Views

### Database views installation

To ensure your Power BI report functions correctly, you must first install the necessary database views. This guide will walk you through the process of running the install.ps1 script, which sets up these views using a configuration file (config.json).

1. Go to the Installer folder
   ```cd Installer```
2. Configuration file
   Verify you have the ```installer/config.json``` file. You can use the config.example.json as example.
   Parameters:
   * DataStandard: Specifies the version of the DataStandard you are using. Possible values:
     * Ds33: For DataStandard 3.3
     * Ds4: For DataStandard 4.0
   * DatabaseEngine: Specifies the database engine to use. Possible values are:
     * "mssql": For Microsoft SQL Server
     * "postgresql": For PostgreSQL
   * ConnectionString: Contains the connection details for the database. This is a nested object with the following properties:
     * Server: The name or IP address of the database server
     * Database: The name of the database
     * Username: The username to connect to the database
     * Password: The password to connect to the database
     * Port: (optional) port to connect to the database
     * IntegratedSecurity: (optional) A boolean value indicating whether to use integrated authentication

3. Run the installer
    To install de views run the install.ps1 script
    ```$> ./install.ps1```

    This installer creates two database schemas
    * analytics
    * analytics_config

    Views installed:
    * epp_candidatedim
    * epp_candidatesurveydim
    * epp_financialaidfact
    * epp_evaluationelementratingdim
    * epp_termdescriptordim
    * epp_eppdim
    * epp_racedescriptordim
    * epp_sexdescriptordim
    * rls_studentdataauthorization
    * rls_userdim
    * rls_userstudentdataauthorization
    * rls_userauthorization

## Legal Information

Copyright (c) 2020 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
