
# LAN Subnet
$ipgw = “10.60.1.1”                               # LAN Gateway IP
$ipdns = $dc1ip                                   # LAN DNS IP addresses
$ipprefix = “24”                                  # LAN Subnet CIDR prefix

# LAN Domain Controller 1
$dc1ip = “10.60.1.4”                              # Domain Controller 1's IP address
$dcname = "dc1"                                   # Domain Controller 1's hostname

# RDS
$rdsh1ip = "10.60.1.20"                           # Remote Desktop Session Hosts 1's IP address
$rdsh1name = "rdsh1"                              # Remote Desktop Session Host 1's hostname
$rdsh1fqdn = "rdsh1.int.tatems.cloud"             # Internal FQDN of RD Session Host 1
$rdcb1fqdn = $rdsh1fqdn                           # Internal FQDN of RD Connection Broker
$collectionname = "TatemsApp"                     # Session Collection name
$collectiondescription = "Tatems App Cloud"       # Session Collection description
$applistfile = ".\applist.csv"                  # RemoteApp CSV List. format: A

# Active Directory and Domain Controller
$addomainname = "int.tatems.cloud”                # Active Directory Domain Name
$netbiosname = "TATEMS"                           # Domain Netbios Name
$adforestmode = "WinThreshold"                    # Forest Active Directory functional level
$addomainmode = $adforestmode                     # Domain Active Directory functional level

# DMZ Subnet
$dmzipgw = "10.60.99.1"                           # DMZ Gateway IP
$dmzipprefix = "24"                               # DMZ Subnet CIDR prefix

# Globals
$ipif = (Get-NetAdapter).ifIndex                  # NIC Index
$featureLogPath = “c:\poshlog\featurelog.txt”     # Path to print feature list to after role and feature installation

