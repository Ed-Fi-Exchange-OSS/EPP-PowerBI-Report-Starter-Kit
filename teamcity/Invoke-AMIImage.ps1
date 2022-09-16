# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

<#
.description
    Setup new AWS Image under 'Ed-Fi-EPP-Starter-Kit' Name
.parameter awsPublicImageName
    Public Image Name for Ed-Fi-EPP-Starter-Kit
.parameter awsS3KeyName
    S3 Key Name for EPPPower BI Report StarterKit QuickStart VM
#>

param(
    [string] $awsPublicImageName = 'Ed-Fi-EPP-Starter-Kit',
    [string] $awsS3KeyName = 'EPPPowerBIReportStarterKitQuickStartVM'
)

Import-Module -Force -Scope Global  "$PSScriptRoot/TaskHelper.psm1"

$global:awsNewImageId = $null

function Remove-OldPrivateImage {

    param(
        [Parameter(Mandatory = $true)]  [string] $awsPublicImageName
    )

    $ErrorActionPreference = 'Stop'
    $oldPrivateImageId =(& aws ec2 describe-images --filters "Name=name,Values=$awsPublicImageName" "Name=is-public,Values=false"  "Name=owner-id,Values=258274856018"  --query "Images[*].ImageId" --output text)

    if($null -ne $oldPrivateImageId) {

        Write-Host "Old Private Image Id "$oldPrivateImageId

        $snapShotId =(& aws ec2 describe-images --filters "Name=name,Values=$awsPublicImageName" "Name=is-public,Values=false"  "Name=owner-id,Values=258274856018"  --query "Images[*].BlockDeviceMappings[*].Ebs.SnapshotId"  --output text)
        Write-Host "Old Private Image SnapShot Id " $snapShotId

        aws ec2 deregister-image --image-id $oldPrivateImageId
        Write-Host "The Old Private Image " $oldPrivateImageId "has been deleted successfully!"

        if($null -ne $snapShotId) {
          aws ec2 delete-snapshot --snapshot-id $snapShotId
          Write-Host "The Old Private Image SnapShot " $snapShotId "has been deleted successfully!"
        }
    }
    else
    {
        Write-Host "There is no old Private Image exist now."
    }
}

function Import-AMIImage {
    param(
        [Parameter(Mandatory = $true)]  [string] $awsPublicImageName,
        [Parameter(Mandatory = $true)]  [string] $awsS3KeyName
    )

    $importTaskId =(& aws ec2 import-image --description "$awsPublicImageName-import" --disk-containers Description="$awsPublicImageName",Format="vhdx",UserBucket="{S3Bucket=edfi-starter-kits,S3Key=$awsS3KeyName/ed-fi-starter-kit.vhdx}" --query "ImportTaskId" --output text)
    Write-Host " Original Import Image "$importTaskId " has been started.It will take a while to continue on next step. Please be patient. "

    $isImportImageNotCompleted =$true
    while($isImportImageNotCompleted -eq $true) {

       Start-Sleep -s 10
       $Iscompleted =(& aws ec2 describe-import-image-tasks --import-task-ids $importTaskId  --query "ImportImageTasks[*].Status" --output text)
       if($Iscompleted -eq "completed") {
            $isImportImageNotCompleted =$false
            Write-Host " Original Import Image " $importTaskId "has been completed successfully! "
       }

     }

     $originalImageId =(& aws ec2 describe-import-image-tasks  --import-task-ids $importTaskId  --query "ImportImageTasks[*].ImageId" --output text)

     $originalSnapShotId =(& aws ec2 describe-import-image-tasks  --import-task-ids $importTaskId  --query "ImportImageTasks[*].SnapshotDetails[*].SnapshotId"  --output text)

     $newimageId =(& aws ec2 copy-image --source-image-id $originalImageId  --source-region us-east-2 --region us-east-2 --name $awsPublicImageName --description $awsPublicImageName --query "ImageId" --output text)

     $global:awsNewImageId = $newimageId
     Write-Host "global New Image Id " $global:awsNewImageId
     Write-Host "Copy to new Image " $newimageId " process has been started, It will take a while to complete this step, Basically adding name " $awsPublicImageName "to image"

    $isNewImageNotAvailable =$true
    while($isNewImageNotAvailable -eq $true) {

       Start-Sleep -s 10
       $IsAvailable =(& aws ec2 describe-images  --image-ids  $newimageId  --filters "Name=name,Values=$awsPublicImageName" "Name=state,Values=available" --query "Images[*].State"  --output text)
       if($IsAvailable -eq "available") {
            $isNewImageNotAvailable =$false
            Write-Host " New Image " $newimageId "has been copied successfully!"
       }

     }

    aws ec2 deregister-image --image-id $originalImageId
    Write-Host "The original image " $originalImageId "has been deleted successfully!"

    aws ec2 delete-snapshot --snapshot-id $originalSnapShotId
}

function Set-TagToAMI {

    Write-Host "global New Image ID" $global:awsNewImageId
    $newimageId = $global:awsNewImageId
    aws ec2 create-tags --resources $newimageId  --tags Key=Schedule,Value=austin-office-hours
    $instanceIdFromTag =(& aws ec2 describe-tags  --filters "Name=resource-id,Values= $newimageId" --query "Tags[*].ResourceId" --output text)
    if($newimageId -eq $instanceIdFromTag){
    Write-Host "New Tag with Key=Schedule,Value=austin-office-hours has been created successfully for this image " $newimageId
    }

}

function Invoke-AMIImage {

    $script:result = @()

    $elapsed = Use-StopWatch {
        try {
            $script:result += Invoke-Task -name "Remove-OldPrivateImage" -task { Remove-OldPrivateImage  $awsPublicImageName}
            $script:result += Invoke-Task -name "Import-AMIImage" -task { Import-AMIImage $awsPublicImageName $awsS3KeyName }
            $script:result += Invoke-Task -name "Set-TagToAMI" -task { Set-TagToAMI  }
        }
        finally {}

    }

    Test-Error

    $script:result += New-TaskResult -name '-' -duration '-'
    $script:result += New-TaskResult -name $MyInvocation.MyCommand.Name -duration $elapsed.format
    return $script:result | Format-Table
}

Invoke-AMIImage
