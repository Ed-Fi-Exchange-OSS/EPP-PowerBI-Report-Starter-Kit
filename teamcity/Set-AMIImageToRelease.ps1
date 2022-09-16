# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

<#
.description
    publish private  AWS Image under 'Ed-Fi-EPP-Starter-Kit' Name to public image
.parameter awsPublicImageName
    Public Image Name for Ed-Fi-EPP-Starter-Kit
#>

param(
    [string] $awsPublicImageName = 'Ed-Fi-EPP-Starter-Kit'
)

Import-Module -Force -Scope Global  "$PSScriptRoot/TaskHelper.psm1"


function Set-AMIImageToPublic {
    param(
        [Parameter(Mandatory = $true)]  [string] $awsPublicImageName
    )

    $ErrorActionPreference = 'Stop'
    $newimageId =(& aws ec2 describe-images --filters "Name=name,Values=$awsPublicImageName" "Name=is-public,Values=false"  "Name=owner-id,Values=258274856018"  --query "Images[*].ImageId" --output text)

    if($null -ne $newimageId){
        aws ec2 modify-image-attribute   --image-id $newimageId   --launch-permission "Add=[{Group=all}]"
        $IsAvaialbleInPublic =(& aws ec2 describe-images  --image-ids $newimageId  --filters "Name=name,Values=$awsPublicImageName" "Name=state,Values=available" --query "Images[*].Public"  --output text)
        if($IsAvaialbleInPublic){
            Write-Host "Turn on  Public visibility for this image " $newimageId "and ready to use for public!"
        }
        else
        {
            Write-Host "Public visibility is not set to image  " $newimageId
        }
    }
    else
    {
        Write-Host "There is no image available in %aws.PublicImageName% to deploy to public"
        exit(1)
    }
}


function Set-AMIImageToRelease {

    $script:result = @()

    $elapsed = Use-StopWatch {
        try {
            $script:result += Invoke-Task -name "Set-AMIImageToPublic" -task { Set-AMIImageToPublic  $awsPublicImageName}
        }
        finally {}

    }

    Test-Error

    $script:result += New-TaskResult -name '-' -duration '-'
    $script:result += New-TaskResult -name $MyInvocation.MyCommand.Name -duration $elapsed.format
    return $script:result | Format-Table
}

Set-AMIImageToRelease
