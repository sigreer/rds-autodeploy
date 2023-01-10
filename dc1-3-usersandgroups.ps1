# Import deployment variables
. .\deployment.ps1

# AD Users and Groups
Import-Module ActiveDirectory

Add-ADGroupMember -Identity "Remote Desktop Users" -Member $adminuser
Add-ADGroupMember -Identity "Remote Admins" -Member $adminuser
Add-ADGroupMember -Identity "Domain Admins" -Member $adminuser
Add-ADGroupMember -Identity "Remote Desktop Users" -Member $adminuser