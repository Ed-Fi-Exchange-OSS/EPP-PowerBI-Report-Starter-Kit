
variable "archive_name" {
  type = string
}

variable "landing_page" {
  type    = string
}

variable "amt" {
  type = string
}

variable "web_api" {
  type = string
}

variable "admin_app" {
  type = string
}

variable "swagger_ui" {
  type = string
}

variable "databases" {
  type = string
}

variable "claimSets" {
  type = string
}

variable "cpus" {
  type = string
}

variable "debug_mode" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "headless" {
  type = string
}

variable "hw_version" {
  type = string
}

variable "memory" {
  type = string
}

variable "shutdown_command" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_switch" {
  type = string
}

variable "iso_url" {
  type    = string
}

variable "distribution_directory" {
  type = string
}

variable "user_name" {
  type = string
}

variable "password" {
  type = string
}

variable "base_image_directory" {
  type = string
}

variable "starter_kit_directory" {
  type = string
}

variable "power_bi_clinical_experience" {
  type = string
}

variable "power_bi_epp_diversity_completion" {
  type = string
}

packer {
  required_plugins {
    comment = {
      version = ">=v0.2.23"
      source = "github.com/sylviamoss/comment"
    }
  }
}

source "hyperv-vmcx" "sea-starter-kit" {
  clone_from_vmcx_path = "${path.root}/${var.base_image_directory}/"
  communicator         = "winrm"
  cpus                 = "${var.cpus}"
  headless             = "${var.headless}"
  memory               = "${var.memory}"
  shutdown_command     = "${var.shutdown_command}"
  switch_name          = "${var.vm_switch}"
  vm_name              = "${var.vm_name}"
  winrm_password       = "${var.password}"
  winrm_timeout        = "10000s"
  winrm_username       = "${var.user_name}"
  output_directory     = "${path.root}/${var.distribution_directory}"
}

build {
  sources = ["source.hyperv-vmcx.sea-starter-kit"]

  provisioner "comment" {
    comment          = "Installing PowerBI Desktop"
    ui               = true
    bubble_text      = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
        "$ErrorActionPreference = 'Stop'",
        "choco install powerbi -y --ignore-pending-reboot --ignore-checksums --execution-timeout=$installTimeout",
        "Remove-Item \"C:/Users/*/Desktop/Power BI*.lnk\" -Force"
    ]
  }

  provisioner "comment" {
    comment     = "Copying ${var.archive_name}.zip to c:/temp"
    ui          = true
    bubble_text = false
  }

  provisioner "file" {
    destination = "c:/temp/"
    sources     = [
      "${path.root}/build/${var.archive_name}.zip",
      "${path.root}/build/${var.landing_page}.zip",
      "${path.root}/build/${var.web_api}.zip",
      "${path.root}/build/${var.admin_app}.zip",
      "${path.root}/build/${var.swagger_ui}.zip",
      "${path.root}/build/${var.amt}.zip",
      "${path.root}/build/${var.databases}.zip",
      "${path.root}/build/${var.claimSets}.zip",
      "${path.root}/build/${var.power_bi_clinical_experience}.zip",
      "${path.root}/build/${var.power_bi_epp_diversity_completion}.zip"
    ]
  }

  provisioner "comment" {
    comment     = "Extracting ${var.archive_name}.zip to c:/temp/${var.archive_name}"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp",
      "Expand-Archive ./${var.archive_name}.zip -Destination ./${var.archive_name}"
    ]
  }

  provisioner "comment" {
    comment     = "Extracting PowerBI visualization files"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "New-Item -ItemType Directory -Path C:/Ed-Fi-Starter-Kit/PowerBI/",
      "Set-Location c:/temp",
      "Expand-Archive \"./${var.power_bi_clinical_experience}.zip\" -Destination \"C:/${var.starter_kit_directory}/PowerBI/${var.power_bi_clinical_experience}\"",
      "Expand-Archive \"./${var.power_bi_epp_diversity_completion}.zip\" -Destination \"C:/${var.starter_kit_directory}/PowerBI/${var.power_bi_epp_diversity_completion}\"",
      "$WshShell = New-Object -comObject WScript.Shell",
      "$Shortcut = $WshShell.CreateShortcut(\"C:/Users/Public/Desktop/Ed-Fi EPP Performance.lnk\")",
      "$Shortcut.TargetPath = \"c:/${var.starter_kit_directory}/PowerBI/${var.power_bi_clinical_experience}/Ed-Fi EPP Performance.pbix\"",
      "$Shortcut.Save()",
      "$WshShell = New-Object -comObject WScript.Shell",
      "$Shortcut = $WshShell.CreateShortcut(\"C:/Users/Public/Desktop/Ed-Fi EPP Diversity and Completion.lnk\")",
      "$Shortcut.TargetPath = \"c:/${var.starter_kit_directory}/PowerBI/${var.power_bi_epp_diversity_completion}/Ed-Fi EPP Diversity and Completion.pbix\"",
      "$Shortcut.Save()"
    ]
  }

  provisioner "comment" {
    comment     = "Extracting ${var.landing_page}.zip to desktop"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
        "Set-Location c:/temp",
        "Expand-Archive ./${var.landing_page}.zip -Destination ./${var.landing_page}",
        "((Get-Content -path \"./${var.landing_page}/docs/TPDM Starter Kits.html\" -Raw) -replace '@@DOMAINNAME@@',[Environment]::MachineName) | Set-Content -Path \"./${var.landing_page}/docs/TPDM Starter Kits.html\"",
        "Copy-Item -Recurse -Path ./${var.landing_page}/docs/ -Destination c:/${var.starter_kit_directory}/LandingPage",
        "$WshShell = New-Object -comObject WScript.Shell",
        "$Shortcut = $WshShell.CreateShortcut(\"C:/Users/Public/Desktop/Start Here.lnk\")",
        "$Shortcut.TargetPath = \"c:/${var.starter_kit_directory}/LandingPage/TPDM Starter Kits.html\"",
        "$Shortcut.IconLocation = \"https://edfidata.s3-us-west-2.amazonaws.com/Starter+Kits/images/favicon.ico\"",
        "$Shortcut.Save()"
    ]
  }


  provisioner "comment" {
    comment     = "Installing Databases"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp",
      "Expand-Archive ./${var.databases}.zip -Destination ./${var.databases}",
      "Expand-Archive ./${var.claimSets}.zip -Destination ./${var.databases}/Ed-Fi-ODS-Implementation/Artifacts/MsSql/Data/Security/",
      "Copy-Item -Path ./${var.archive_name}/configuration.json -Destination ./${var.databases}",
      "Copy-Item -Path ./${var.archive_name}/sampledata.ps1 -Destination ./${var.databases}/Ed-Fi-ODS-Implementation/DatabaseTemplate/Scripts/",
      "Set-Location ./${var.databases}",
      "Import-Module -Force -Scope Global SqlServer",
      "Import-Module ./Deployment.psm1",
      "Initialize-DeploymentEnvironment "
    ]
  }
  
  provisioner "comment" {
    comment     = "Installing AMT Views"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp/${var.archive_name}/installers",
	  "$configPath = \"c:/temp/${var.archive_name}/configuration.json\"",
      "Import-Module -Force \"c:/temp/${var.archive_name}/modules/config-helper.psm1\"",
	  "$configuration = Format-ConfigurationFileToHashTable $configPath",
      "Import-Module -Force \"c:/temp/${var.archive_name}/installers/EdFi-AMT.psm1\" -ArgumentList $configuration",
	  "Write-Host 'Installing AMT...' -ForegroundColor Cyan",
	  "$parameters = @{",
      "databasesConfig          = $configuration.databasesConfig",
      "amtDownloadPath          = $configuration.amtConfig.amtDownloadPath",
      "amtInstallerPath         = $configuration.amtConfig.amtInstallerPath",
      "amtOptions               = $configuration.amtConfig.options}",
	  "Install-amt @parameters",
      "Write-Host 'AMT has been installed' -ForegroundColor Cyan"
    ]
  }
  
  provisioner "comment" {
    comment     = "Api Client Setup"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp/${var.archive_name}",
      "./apiclient-setup.ps1"
    ]
  }

  provisioner "comment" {
    comment     = "Installing ODS/API"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp",
      "Expand-Archive ./${var.web_api}.zip -Destination ./${var.web_api}",
      "Set-Location c:/temp/${var.archive_name}/installers",
      "./Install-WebApi.ps1",
      "Copy-Item -Path c:/temp/${var.archive_name}/webapi.appsettings.production.json -Destination C:/inetpub/Ed-Fi/WebApi/appsettings.production.json"
    ]
  }

  provisioner "comment" {
    comment     = "Installing SwaggerUI"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp",
      "Expand-Archive ./${var.swagger_ui}.zip -Destination ./${var.swagger_ui}",
      "Set-Location c:/temp/${var.archive_name}/installers",
      "./Install-SwaggerUI.ps1"
    ]
  }

  provisioner "comment" {
    comment     = "Installing Admin App"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Set-Location c:/temp",
      "Expand-Archive ./${var.admin_app}.zip -Destination ./${var.admin_app}",
      "Set-Location c:/temp/${var.archive_name}/installers",
      "./Install-AdminApp.ps1"
    ]
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Remove-item c:/temp/* -Recurse -Force",
      "Optimize-Volume -DriveLetter C"
    ]
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
      "$ErrorActionPreference = 'Stop'",
      "Write-Host (\"Web Api => https://{0}/WebApi\" -f [Environment]::MachineName)",
      "Write-Host (\"Admin App => https://{0}/AdminApp\" -f [Environment]::MachineName)",
      "Write-Host (\"SwaggerUI => https://{0}/SwaggerUI\" -f [Environment]::MachineName)"
    ]
  }
}
