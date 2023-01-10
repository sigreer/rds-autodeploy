# Import deployment variables
. .\deployment.ps1

Add-WindowsFeature RDS-Connection-Broker,RDS-RD-Server,RDS-Licensing,RDS-Web-Access,RDS-Licensing-UI



# Creates RD Session Collection
New-RDSessionCollection `
    –CollectionName $collectionname `
    –SessionHost $rdsh1fqdn `
    –CollectionDescription $collectiondescription `
    –ConnectionBroker $rdcbfqdn


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