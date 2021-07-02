# EPP PowerBI Report Starter-Kit

## Steps to build EPP PowerBI Report Starter-Kit Automated Machine Image

This README outlines the steps for creating a virtual hard disk image containing
an evaluation copy of Windows 2019 Server, with SQL Server 2019 Express edition,
SQL Server Management Studio, Google Chrome, the Dot Net
Core SDK, and NuGet Package Manager.

### Clone the repo

Clone the [EPP-PowerBI-Report-Starter-Kit repository](https://github.com/Ed-Fi-Exchange-OSS/EPP-PowerBI-Report-Starter-Kit)

### Turn on Windows features for Hyper-V

  You will need both sub-items: Hyper-V Platform and Hyper-V Management Tools.
  For directions on enabling these features, follow the directions found
  [here](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-the-hyper-v-role-through-settings)

### Download an install Packer

```powershell
choco install Packer
```
### Open a PowerShell console (greater or equal to PSVersion 5) in elevated mode

Set your location in the console to the EPP-PowerBI-Report-Starter-Kit\packer folder.
Execute the build-vm.ps1 to create your VM.

### Optional Parameters
There are two optional parameters that you can pass to the build script for
specific scenarios. The first is if you have a Hyper-V VM Switch defined in
Hyper-V already you can add `-vmSwitch` along with the name of your Switch.
If this parameter is not specified, then a Switch with the name
`packer-hyperv-iso` will be created. The second optional parameter is for if you
run the build and see the following error output

```
hyperv-iso: Download failed unexpected EOF
hyperv-iso: error downloading ISO: [unexpected EOF]
...
Build 'hyperv-iso' errored after 10 minutes 26 seconds: error downloading ISO: [unexpected EOF]
```

If you see this, then the build is having a problem downloading the Windows
Server 2019 iso file, so you should try to manually download the iso from [this
url](https://software-download.microsoft.com/download/pr/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso),
move the iso file to an easily accessible location, and then use the `-isoUrl`
parameter in the build script to specifiy where the iso file is and the build
script will use that file instead of trying to download it.


# Packer Build

| Folder | Description |
| -------- | -------- |
| `build/` | Cached artifacts and log files |
| `dist/` | Built virtual machine |
| `mnt/` | Used by packer to mount to the floppy drive |

Below are examples showing how to pass these parameters to the build script for base image build .

```powershell
#default way to run build for base image to generate the base image. Folders that are created during the build process are `./build` and `./dist`.
PS> ./build-vm.ps1 -PackerFile .\win2019-eval-base.pkr.hcl -VariablesFile .\base-variables.json

#build with vmSwitch parameter for base image
PS> ./build-vm.ps1 -PackerFile .\win2019-eval-base.pkr.hcl -VariablesFile .\base-variables.json -VMSwitch existingVMSwitchName
```

After the base build, copy the contents of `dist` folder to `build` folder and procede with full starter kit image build.
Below are examples showing how to pass these parameters to the build script for starter kit image build.

```powershell
#default way to run build for starter-kit image to generate the starter-kit image. Folders that are created during the build process are `./build` and `./dist`.
PS> ./build-vm.ps1 -PackerFile .\epp-starter-kit-win2019-eval.pkr.hcl -VariablesFile .\starter-kit-variables.json


#build with vmSwitch parameter for starter-kit image
PS> ./build-vm.ps1 -PackerFile .\epp-starter-kit-win2019-eval.pkr.hcl -VariablesFile .\starter-kit-variables.json -VMSwitch existingVMSwitchName

```
> :exclamation: IMPORTANT: Disconnect from any VPNs. This will cause issues with Hypervisor
> connectivity.

The base image build will download and install Windows Server 2019 Evaluation edition, with
a license that is valid for 180 days. NuGet Package Management is installed,
followed by Chocolatey for automated software package installs of the following
software: Dot Net Core 3.1 SDK, SQL Server 2019 Express,
SQL Server Management Studio, Google Chrome, and any of their Chocolatey package
dependencies (Windows update packages for Dot Net).

Next, Starter-kit image build uses the base image provided in build folder and invokes the installation of ODS / API, Admin App, starter kit sample data, starter kit sample extension, sample validation and reporting artifacts.

When complete, the virtual machine artifacts will be created in the `EPP-PowerBI-Report-Starter-Kit\packer\dist\` folder.

## Using the Image
* Open Hyper-V Manager.
* On the right hand side click "Import Virtual Machine".
* In the wizard, click Next.
* Then when it asks you to specify where the virtual machine you want to import is, browse to `EPP-PowerBI-Report-Starter-Kit\packer\dist\` folder which the contains the Hyper-V hard disk images.
* On the next page it should show one virtual machine called "assessment-starter-kit". Make sure it is selected.
* Click Next.
* When choosing the Import Type, leave the default of "Register the virtual machine in place".
* Click Next.
* Click Finish.
* Back in Hyper-V Manager you should now see a VM called "ed-fi-starter-kit".
* Connect to that VM and start it. 
* Log into windows using credentials `Administrator` \ `EdFi!sCool`.

