# Install AD DS, DNS and GPMC
start-job -Name addFeature -ScriptBlock {
Add-WindowsFeature `
    -Name “ad-domain-services” `
    -IncludeAllSubFeature `
    -IncludeManagementTools
Add-WindowsFeature `
    -Name “dns” `
    -IncludeAllSubFeature `
    -IncludeManagementTools
Add-WindowsFeature `
    -Name “gpmc” `
    -IncludeAllSubFeature `
    -IncludeManagementTools `
    }
Wait-Job -Name addFeature
Get-WindowsFeature | Where installed >>$featureLogPath

# Import deployment variables
. .\deployment.ps1

# Create New Forest, add Domain Controller
Import-Module ADDSDeployment
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath “C:\Windows\NTDS” `
    -DomainMode $addomainmode `
    -DomainName $addomainname `
    -DomainNetbiosName $netbiosname `
    -ForestMode $adforestmode `
    -InstallDns:$true `
    -LogPath “C:\Windows\NTDS” `
    -NoRebootOnCompletion:$false `
    -SysvolPath “C:\Windows\SYSVOL” `
    -Force:$true

