<#
.SYNOPSIS
    This function delete AppLocker settings using MDM WMI Bridge
.DESCRIPTION
    This script will delete AppLocker settings
.NOTES
    Credit goes to Sandy Zeng for the orginal idea
    Licensed under the MIT license.
#>

$namespaceName = "root\cimv2\mdm\dmmap" #Do not change this
# DO NOT CHANGE Class Names
$execlassName = "MDM_AppLocker_ApplicationLaunchRestrictions01_EXE03"
$appxclassName = "MDM_AppLocker_ApplicationLaunchRestrictions01_StoreApps03"
$msiclassName = "MDM_AppLocker_MSI03"
$scriptclassName = "MDM_AppLocker_Script03"

$GroupName = "AppLocker001" #Your own groupName
$parentID = "./Vendor/MSFT/AppLocker/ApplicationLaunchRestrictions/$GroupName"

Get-CimInstance -Namespace $namespaceName -ClassName $execlassName -Filter "ParentID=`'$parentID`' and InstanceID='Exe'"  | Remove-CimInstance
Get-CimInstance -Namespace $namespaceName -ClassName $msiclassName -Filter "ParentID=`'$parentID`' and InstanceID='Msi'"  | Remove-CimInstance
Get-CimInstance -Namespace $namespaceName -ClassName $scriptclassName -Filter "ParentID=`'$parentID`' and InstanceID='Script'"  | Remove-CimInstance
Get-CimInstance -Namespace $namespaceName -ClassName $appxclassName -Filter "ParentID=`'$parentID`' and InstanceID='StoreApps'"  | Remove-CimInstance