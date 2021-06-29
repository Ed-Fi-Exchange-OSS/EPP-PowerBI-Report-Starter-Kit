# Packer Build

Execute `./build-vm.ps1 -PackerFile .\win2019-eval-base.pkr.hcl -VariablesFile .\base-variables.json` to generate the base image. Folders that are created during the build process are `./build` and `./dist`.
Execute `./build-vm.ps1 -PackerFile .\sea-starter-kit-win2019-eval.pkr.hcl -VariablesFile .\starter-kit-variables.json` to generate the start kit image. Folders that are created during the build process are `./build` and `./dist`.

| Folder | Description |
| -------- | -------- |
| `build/` | Cached artifacts and log files |
| `dist/` | Built virtual machine |
| `mnt/` | Used by packer to mount to the floppy drive |
