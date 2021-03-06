﻿<# 
 .Synopsis
  Extract Files From NAV Container Image
 .Description
  Extract all files from a NAV Container Image necessary to start a generic container with these files
 .Parameter imageName
  Name of the NAV Container Image from which you want to extract the files
 .Parameter path
  Location where you want the files to be placed
 .Parameter extract
  Determine what you need to extract (default is all)
 .Parameter force
  Specify -force if you want to automatically remove the destination folder if it exists
 .Example
  Extract-FilesFromNavContainerImage -ImageName microsoft/bcsandbox:us -Path "c:\programdata\navcontainerhelper\extensions\acontainer\afolder"
#>
function Extract-FilesFromNavContainerImage {
    [CmdletBinding()]
    Param
    (
        [string] $imageName,
        [string] $path,
        [ValidateSet('all','vsix','database')]
        [string] $extract = "all",
        [switch] $force
    )

    $ErrorActionPreference = 'Continue'

    Write-Host "Creating temp container from $imagename and extract necessary files"
    $containerName = "navcontainerhelper-temp"
    docker rm $containerName 2>$null | Out-null
    docker create --name $containerName $imagename | Out-Null

    $ErrorActionPreference = 'Stop'

    Extract-FilesFromStoppedNavContainer -containerName $containerName -path $path -extract $extract -force:$force
    
    $ErrorActionPreference = 'Continue'

    Write-Host "Removing temp container"
    docker rm $containerName 2>$null | Out-null

    $ErrorActionPreference = 'Stop'
}
Export-ModuleMember -function Extract-FilesFromNavContainerImage
