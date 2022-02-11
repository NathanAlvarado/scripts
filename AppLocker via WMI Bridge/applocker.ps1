<#
.DESCRIPTION
    This script will create new AppLocker settings or update existing settings using MDM Bridge WMI Provider
.NOTES
    Credit goes to Sandy Zeng for the orginal idea https://github.com/sandytsang/MSIntune/tree/master/Intune-PowerShell/AppLocker
    Licensed under the MIT license.
#>

# Set the Application Identity service to auto
sc.exe config appidsvc start= auto

# Do not change namespace or classnames
$namespaceName = "root\cimv2\mdm\dmmap"
$execlassName = "MDM_AppLocker_ApplicationLaunchRestrictions01_EXE03"
$msiclassName = "MDM_AppLocker_MSI03"
$scriptclassName = "MDM_AppLocker_Script03"
$appxclassName = "MDM_AppLocker_ApplicationLaunchRestrictions01_StoreApps03"

$GroupName = "AppLocker001" #You can use your own Groupname, don't use special charaters or white space
$parentID = "./Vendor/MSFT/AppLocker/ApplicationLaunchRestrictions/$GroupName"

$existEXE = Get-CimInstance -Namespace $namespaceName -ClassName $execlassname -Filter "ParentID=`'$parentID`' and InstanceID='EXE'"
$existMSI = Get-CimInstance -Namespace $namespaceName -ClassName $msiclassName -Filter "ParentID=`'$parentID`' and InstanceID='MSI'"
$existSCRIPT = Get-CimInstance -Namespace $namespaceName -ClassName $scriptclassName -Filter "ParentID=`'$parentID`' and InstanceID='SCRIPT'"
$existAPPX = Get-CimInstance -Namespace $namespaceName -ClassName $appxclassName -Filter "ParentID=`'$parentID`' and InstanceID='STOREAPPS'"

Add-Type -AssemblyName System.Web

# AppLocker XML

$xmlEXE = [System.Net.WebUtility]::HtmlEncode(@"
<RuleCollection Type="Exe" EnforcementMode="Enabled">
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
    <FilePublisherRule Id="5c895db3-d32a-4f81-adf3-711904d7c86b" Name="Allow Google Software" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=GOOGLE LLC, L=MOUNTAIN VIEW, S=CALIFORNIA, C=US" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePublisherRule Id="6a970cf4-9d41-441e-a677-1e0f66c9733c" Name="Allow Microsoft Software" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePublisherRule Id="7646b5ef-5323-4e69-ac77-ee7a351632ad" Name="Allow Logitech Software" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=LOGITECH INC, L=NEWARK, S=CALIFORNIA, C=US" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePublisherRule Id="353a25ec-bb46-4132-8dc9-b009a87fc836" Name="Allow Amazon Software" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=AMAZON.COM SERVICES LLC, L=SEATTLE, S=WASHINGTON, C=US" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePublisherRule Id="81a5edb6-80e0-4535-b7d9-f8163ec5748e" Name="Allow GitHub Softare" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=GITHUB, INC., L=SAN FRANCISCO, S=CALIFORNIA, C=US" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePublisherRule Id="7efa5efc-e910-476d-b489-a33ae590c2e4" Name="Allow Git" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=JOHANNES SCHINDELIN, L=KÖLN, S=NORTH RHINE-WESTPHALIA, C=DE" ProductName="GIT" BinaryName="GIT.EXE">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
    <FilePublisherRule Id="1f740886-0f2a-46cc-93a6-a14d4f2686c7" Name="Allow Zoom Softare" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=ZOOM VIDEO COMMUNICATIONS, INC., L=SAN JOSE, S=CALIFORNIA, C=US" ProductName="*" BinaryName="*">
          <BinaryVersionRange LowSection="*" HighSection="*" />
        </FilePublisherCondition>
      </Conditions>
    </FilePublisherRule>
</RuleCollection>
"@) 
$existEXE.Policy = $xmlEXE

$xmlMSI = [System.Net.WebUtility]::HtmlEncode(@"
  <RuleCollection Type="Msi" EnforcementMode="Enabled">
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
  <RuleCollection Type="Script" EnforcementMode="Enabled">
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
  <RuleCollection Type="Appx" EnforcementMode="Enabled">
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

# Create policies or Update policies if they are already created
if (!$existEXE) {
  New-CimInstance -Namespace $namespaceName -ClassName $execlassName -Property @{ParentID=$parentID;InstanceID="Exe";Policy=$xmlEXE}
}
else {
  Set-CimInstance -CimInstance $existEXE
}

if (!$existMSI) {
  New-CimInstance -Namespace $namespaceName -ClassName $msiclassName -Property @{ParentID=$parentID;InstanceID="Msi";Policy=$xmlMSI}
}
else {
  Set-CimInstance -CimInstance $existMSI
}

if (!$existSCRIPT) {
  New-CimInstance -Namespace $namespaceName -ClassName $scriptclassName -Property @{ParentID=$parentID;InstanceID="Script";Policy=$xmlSCRIPT}
}
else {
  Set-CimInstance -CimInstance $existSCRIPT
}

if (!$existAPPX) {
  New-CimInstance -Namespace $namespaceName -ClassName $appxclassName -Property @{ParentID=$parentID;InstanceID="StoreApps";Policy=$xmlAPPX}
}
else {
  Set-CimInstance -CimInstance $existAPPX
}