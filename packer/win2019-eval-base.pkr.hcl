variable "cpus" {
  type    = string
}

variable "debug_mode" {
  type    = string
}

variable "disk_size" {
  type    = string
}

variable "headless" {
  type    = string
}

variable "hw_version" {
  type    = string
}

variable "iso_checksum" {
  type    = string
}

variable "iso_url" {
  type    = string
}

variable "memory" {
  type    = string
}

variable "shutdown_command" {
  type    = string
}

variable "version" {
  type    = string
}

variable "vm_switch" {
  type    = string
}

variable "user_name" {
    type = string
}

variable "password" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "archive_name" {
    type = string
}

variable "distribution_directory" {
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

source "hyperv-iso" "ed-fi-base-image" {
  communicator     = "winrm"
  cpus             = "${var.cpus}"
  disk_size        = "${var.disk_size}"
  floppy_files     = ["${path.root}/mnt/Autounattend.xml"]
  headless         = "${var.headless}"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  memory           = "${var.memory}"
  shutdown_command = "${var.shutdown_command}"
  switch_name      = "${var.vm_switch}"
  vm_name          = "${var.vm_name}"
  winrm_password   = "${var.password}"
  winrm_timeout    = "10000s"
  winrm_username   = "${var.user_name}"
  output_directory = "${path.root}/${var.distribution_directory}"
}

build {
  name= "base"
  sources = ["source.hyperv-iso.ed-fi-base-image"]

  provisioner "comment" {
    comment     = "Copying server-setup.ps1 to c:/temp"
    ui          = true
    bubble_text =  false
  }

  provisioner "file" {
    destination = "c:/temp/"
    sources     = [
        "${path.root}/build/${var.archive_name}.zip"
    ]
  }

  provisioner "comment" {
    comment     = "Installing PowerShell package manager"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
        "Set-ExecutionPolicy bypass -Scope CurrentUser -Force;",
        "Install-PackageProvider -Name NuGet -MinimumVersion \"2.8.5.201\" -Scope AllUsers -Force",
        "Install-Module -Name PackageManagement -Force -MinimumVersion \"1.4.6\" -Scope CurrentUser -AllowClobber -Repository PSGallery"
      ]
  }

  provisioner "comment" {
    comment     = "Exctacting ${var.archive_name}.zip to c:/temp/${var.archive_name}"
    ui          = true
    bubble_text = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
        "Set-Location c:/temp",
        "Expand-Archive ./${var.archive_name}.zip -Destination ./${var.archive_name}"
    ]
  }

  provisioner "comment" {
    comment          = "Executing c:/temp/${var.archive_name}/server-setup.ps1"
    ui               = true
    bubble_text      = false
  }

  provisioner "powershell" {
    debug_mode        = "${var.debug_mode}"
    elevated_password = "${var.password}"
    elevated_user     = "${var.user_name}"
    inline            = [
        "Set-Location c:/temp/${var.archive_name}/",
        "./server-setup.ps1",
        "Set-Location c:/",
        "Remove-item c:/temp/* -Recurse -Force",
        "Optimize-Volume -DriveLetter C"
    ]
  }

  provisioner "comment" {
    comment     = "Server Setup complete. Restarting...."
    ui          = true
    bubble_text =  false
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'Server Setup complete. Restarting....'}\""
  }
}
