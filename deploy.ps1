. \deployment-variables.ps1   # Import the variables for the whole environment

# Set permissive enough execution policy
# Set-ExecutionPolicy remotesigned -force
workflow Config-TatemsDC
{
# Set IP and network parameters
New-NetIPAddress `
    -IPAddress $dc1ip `
    -PrefixLength $ipprefix `
    -InterfaceIndex $ipif `
    -DefaultGateway $ipgw

#rename the computer
Rename-Computer -NewName $dcname -force

# Create log file output location for installing features
New-Item $featureLogPath -ItemType file -Force

# Add the RSAT-AD-Tools module which installs everything else as a dependency
$addsTools = “RSAT-AD-Tools”
Add-WindowsFeature $addsTools

# Write the feature list to the previously stated log file
Get-WindowsFeature | Where installed >>$featureLogPath # Write the featurelist to log

# Restart when finished
Restart-Computer -wait -PSComputerName $dc1name -Force

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
}

# Import CSV of App Users to Active Directory and Assign to AppUsers Group
workflow Add-OrgADUsers 
{
Import-Module ActiveDirectory
$userslist = Import-Csv `
    -Path $usersfile `
    -Delimiter "," `
    -Header Name,DisplayName,GivenName,Surname,Company,Organization,OfficePhone,HomeDrive,PasswordNeverExpires,Type,UserPrincipalName
    foreach ($activedirectoryuser in $userslist) {
        New-ADUser `
            -Name $activedirectoryuser.Name `
            -DisplayName $activedirectoryuser.DisplayName `
            -GivenName $activedirectoryuser.GivenName `
            -Surname $activedirectoryuser.Surname `
            -Company $activedirectoryuser.Company `
            -Organization $activedirectoryuser.Organization `
            -OfficePhone $activedirectoryuser.OfficePhone `
            -HomeDrive $activedirectoryuser.HomeDrive `
            -PasswordNeverExpires $activedirectoryuser.PasswordNeverExpires `
            -Type $activedirectoryuser.Type `
            -UserPrincipalName $activedirectoryuser.UserPrincipalName
        New-ADGroupMember -Identity "AppUsers" -Member $activedirectoryuser.Name
    }
}

workflow Config-TatemsRDSH
{
# Set IP and network parameters
New-NetIPAddress `
    -IPAddress $rdsh1ip `
    -PrefixLength $ipprefix `
    -InterfaceIndex $ipif `
    -DefaultGateway $ipgw

#rename the computer
Rename-Computer -NewName $rdsh1name -force

# Create log file output location for installing features
New-Item $featureLogPath -ItemType file -Force

# Add the RSAT-AD-Tools module which installs everything else as a dependency
$addsTools = “RSAT-AD-Tools”
Add-WindowsFeature $addsTools

# Write the feature list to the previously stated log file
Get-WindowsFeature | Where installed >>$featureLogPath # Write the featurelist to log

# Restart when finished
Restart-Computer -wait -PSComputerName $rdsh1name -Force

# Add RDSH Roles and Features
Add-WindowsFeature RDS-Connection-Broker,RDS-RD-Server,RDS-Licensing,RDS-Web-Access
# Restart when done
Restart-Computer -wait -PSComputerName $rdsh1name -Force

# Creates RD Session Collection
New-RDSessionCollection `
    –CollectionName $collectionname `
    –SessionHost $rdsh1fqdn `
    –CollectionDescription $collectiondescription `
    –ConnectionBroker $rdcbfqdn
}

## Publishes apps from CSV file
workflow Add-TatemsApps
{
$applist = Import-Csv `
    -Path $applistfile `
    -Delimiter "," `
    -Header Alias,DisplayName,FilePath,ShowInWebAccess,CollectionName,ConnectionBroker

foreach ($listedapp in $applist)
    {
    New-RDRemoteApp `
        -Alias $listedapp.Alias `
        -DisplayName $listedapp.DisplayName `
        -FilePath $listedapp.FilePath `
        -ShowInWebAccess $listedapp.ShowInWebAccess `
        -CollectionName $collectionname `
        -ConnectionBroker $rdcbfqdn        
    }
}
