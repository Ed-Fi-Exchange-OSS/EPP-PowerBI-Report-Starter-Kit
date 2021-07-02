# Powershell Scripts
These scripts are used for the provisioning process. Packer calls the scripts in the installer folder to install the applications. Modules are common logic.

**_NOTE: build-vm.ps1 also uses file-helper.psm1 in the modules._**

| Script | Description |
| ----------- | ----------- |
| Install-WebApi.ps1 | Installs ODS/API|
| Install-SwaggerUI.ps1 | Installs SwaggerUI |
| Install-AdminApp.ps1 | Installs AdminApp |
| server-setup.ps1 | Installs all the necessary components on the server |

| Configuration File | Usage |
| ----------- | ----------- |
| configuration.json | Used by the database deployment script |
| app-configuration.json | Used by the install scripts to pull the correct version of the applications |
