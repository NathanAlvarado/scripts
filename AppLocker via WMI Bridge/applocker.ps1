<#
.SYNOPSIS
    This function create new AppLocker settings using MDM Bridge WMI Provider
.DESCRIPTION
    This script will create default AppLocker settings for Auditing
.NOTES
    Credit goes to Sandy Zeng for the orginal idea https://github.com/sandytsang/MSIntune/tree/master/Intune-PowerShell/AppLocker
    Licensed under the MIT license.
#>

# Set the Application Identity service to auto
sc.exe config appidsvc start= auto

$namespaceName = "root\cimv2\mdm\dmmap" #Do not change this

# DO NOT CHANGE Class Names
$execlassName = "MDM_AppLocker_ApplicationLaunchRestrictions01_EXE03"
$msiclassName = "MDM_AppLocker_MSI03"
$scriptclassName = "MDM_AppLocker_Script03"
$appxclassName = "MDM_AppLocker_ApplicationLaunchRestrictions01_StoreApps03"

$GroupName = "AppLocker001" #You can use your own Groupname, don't use special charaters or with space
$parentID = "./Vendor/MSFT/AppLocker/ApplicationLaunchRestrictions/$GroupName"

$existEXE = Get-CimInstance -Namespace $namespaceName -ClassName $execlassname -Filter "ParentID=`'$parentID`' and InstanceID='EXE'"
$existMSI = Get-CimInstance -Namespace $namespaceName -ClassName $msiclassName -Filter "ParentID=`'$parentID`' and InstanceID='MSI'"
$existSCRIPT = Get-CimInstance -Namespace $namespaceName -ClassName $scriptclassName -Filter "ParentID=`'$parentID`' and InstanceID='SCRIPT'"
$existAPPX = Get-CimInstance -Namespace $namespaceName -ClassName $appxclassName -Filter "ParentID=`'$parentID`' and InstanceID='STOREAPPS'"


Add-Type -AssemblyName System.Web

# AppLocker XML

$xmlEXE = [System.Net.WebUtility]::HtmlEncode(@"
<RuleCollection Type="Exe" EnforcementMode="AuditOnly">
    <FilePathRule Id="921cc481-6e17-4653-8f75-050b80acca20" Name="(Default Rule) All files located in the Program Files folder" Description="Allows members of the Everyone group to run applications that are located in the Program Files folder." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%PROGRAMFILES%\*" />
      </Conditions>
    </FilePathRule>
    <FilePathRule Id="a61c8b2c-a319-4cd0-9690-d2177cad7b51" Name="(Default Rule) All files located in the Windows folder" Description="Allows members of the Everyone group to run applications that are located in the Windows folder." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%WINDIR%\*" />
      </Conditions>
    </FilePathRule>
    <FilePathRule Id="fd686d83-a829-4351-8ff4-27c7de5755d2" Name="(Default Rule) All files" Description="Allows members of the local Administrators group to run all applications." UserOrGroupSid="S-1-5-32-544" Action="Allow">
      <Conditions>
        <FilePathCondition Path="*" />
      </Conditions>
    </FilePathRule>
    <FilePublisherRule Id="6a970cf4-9d41-441e-a677-1e0f66c9733c" Name="MICROSOFT TEAMS, from O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US" ProductName="MICROSOFT TEAMS" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
</RuleCollection>
"@) 
$existEXE.Policy = $xmlEXE

$xmlMSI = [System.Net.WebUtility]::HtmlEncode(@"
  <RuleCollection Type="Msi" EnforcementMode="AuditOnly">
    <FilePublisherRule Id="b7af7102-efde-4369-8a89-7a6a392d1473" Name="(Default Rule) All digitally signed Windows Installer files" Description="Allows members of the Everyone group to run digitally signed Windows Installer files." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="*" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="0.0.0.0" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePathRule Id="5b290184-345a-4453-b184-45305f6d9a54" Name="(Default Rule) All Windows Installer files in %systemdrive%\Windows\Installer" Description="Allows members of the Everyone group to run all Windows Installer files located in %systemdrive%\Windows\Installer." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%WINDIR%\Installer\*" />
      </Conditions>
    </FilePathRule>
    <FilePathRule Id="64ad46ff-0d71-4fa0-a30b-3f3d30c5433d" Name="(Default Rule) All Windows Installer files" Description="Allows members of the local Administrators group to run all Windows Installer files." UserOrGroupSid="S-1-5-32-544" Action="Allow">
      <Conditions>
        <FilePathCondition Path="*.*" />
      </Conditions>
    </FilePathRule>
  </RuleCollection>
"@)
$existMSI.Policy = $xmlMSI

$xmlSCRIPT = [System.Net.WebUtility]::HtmlEncode(@"
  <RuleCollection Type="Script" EnforcementMode="AuditOnly">
    <FilePathRule Id="06dce67b-934c-454f-a263-2515c8796a5d" Name="(Default Rule) All scripts located in the Program Files folder" Description="Allows members of the Everyone group to run scripts that are located in the Program Files folder." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%PROGRAMFILES%\*" />
      </Conditions>
    </FilePathRule>
    <FilePathRule Id="9428c672-5fc3-47f4-808a-a0011f36dd2c" Name="(Default Rule) All scripts located in the Windows folder" Description="Allows members of the Everyone group to run scripts that are located in the Windows folder." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%WINDIR%\*" />
      </Conditions>
    </FilePathRule>
    <FilePathRule Id="ed97d0cb-15ff-430f-b82c-8d7832957725" Name="(Default Rule) All scripts" Description="Allows members of the local Administrators group to run all scripts." UserOrGroupSid="S-1-5-32-544" Action="Allow">
      <Conditions>
        <FilePathCondition Path="*" />
      </Conditions>
    </FilePathRule>
  </RuleCollection>
"@)
$existSCRIPT.Policy = $xmlSCRIPT

$xmlAPPX = [System.Net.WebUtility]::HtmlEncode(@"
  <RuleCollection Type="Appx" EnforcementMode="AuditOnly">
    <FilePublisherRule Id="a9e18c21-ff8f-43cf-b9fc-db40eed693ba" Name="(Default Rule) All signed packaged apps" Description="Allows members of the Everyone group to run packaged apps that are signed." UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="*" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="0.0.0.0" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
  </RuleCollection>
"@)
$existAPPX.Policy = $xmlAPPX

$existEXE = Get-CimInstance -Namespace $namespaceName -ClassName $execlassname -Filter "ParentID=`'$parentID`' and InstanceID='EXE'"
$existMSI = Get-CimInstance -Namespace $namespaceName -ClassName $msiclassName -Filter "ParentID=`'$parentID`' and InstanceID='MSI'"
$existSCRIPT = Get-CimInstance -Namespace $namespaceName -ClassName $scriptclassName -Filter "ParentID=`'$parentID`' and InstanceID='SCRIPT'"
$existAPPX = Get-CimInstance -Namespace $namespaceName -ClassName $appxclassName -Filter "ParentID=`'$parentID`' and InstanceID='STOREAPPS'"

# Create policies or Update policies if they are already created
if (!$existEXE) {
  # Policy does not exist, time to create it!
  New-CimInstance -Namespace $namespaceName -ClassName $execlassName -Property @{ParentID=$parentID;InstanceID="Exe";Policy=$xmlEXE}
}
  # Policy exists, time to update it!
  Set-CimInstance -CimInstance $existEXE

if (!$existMSI) {
  # Policy does not exist, time to create it!
  New-CimInstance -Namespace $namespaceName -ClassName $msiclassName -Property @{ParentID=$parentID;InstanceID="Msi";Policy=$xmlMSI}
}
  # Policy exists, time to update it!
  Set-CimInstance -CimInstance $existMSI

if (!$existSCRIPT) {
  # Policy does not exist, time to create it!
  New-CimInstance -Namespace $namespaceName -ClassName $scriptclassName -Property @{ParentID=$parentID;InstanceID="Script";Policy=$xmlSCRIPT}
}
  # Policy exists, time to update it!
  Set-CimInstance -CimInstance $existSCRIPT

if (!$existAPPX) {
  # Policy does not exist, time to create it!
  New-CimInstance -Namespace $namespaceName -ClassName $appxclassName -Property @{ParentID=$parentID;InstanceID="StoreApps";Policy=$xmlAPPX}
}
  # Policy exists, time to update it!
  Set-CimInstance -CimInstance $existAPPX