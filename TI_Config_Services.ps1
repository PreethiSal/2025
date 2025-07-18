<#
 # TI Baseline MSI "stuff"
#>

Set-Service -Name ALG -StartupType Disabled
Set-Service -Name SENs -StartupType Manual
Set-Service -Name SSDPSRV -StartupType Disabled
Set-Service -Name upnphost -StartupType Disabled
Set-Service -Name WebClient -StartupType Automatic
Set-Service -Name RemoteRegistry -StartupType Automatic
Set-Service -Name wuauserv -StartupType Automatic

<#
 # TI InfoSec requested
#>

Get-Service -DisplayName 'AllJoyn Router Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Device Management Enrollment Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Downloaded Maps Manager' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Embedded Mode' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Encrypting File System (EFS)' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Fax' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Function Discovery Provider Host' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Function Discovery Resource Publication' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Internet Connection Sharing (ICS)' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Link-Layer Topology Discovery Mapper' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Microsoft Account Sign-in Assistant' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Microsoft Windows SMS Router Service.' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Network Connectivity Assistant' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Payments and NFC/SE Manager' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Peer Name Resolution Protocol' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Peer Networking Grouping' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Peer Networking Identity Manager' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Phone Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'PNRP Machine Name Publication Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Retail Demo Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Routing and Remote Access' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Shared PC Account Manager' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'SNMP Trap' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'SSDP Discovery' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Telephony' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'UPnP Device Host' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'WalletService' | Set-service -StartupType Disabled
Get-Service -DisplayName 'Windows Media Player Network Sharing Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Windows Mobile Hotspot Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'WinHTTP Web Proxy Auto-Discovery Service' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Xbox Live Auth Manager' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Xbox Live Game Save' | Set-Service -StartupType Disabled
Get-Service -DisplayName 'Xbox Live Networking Service' | Set-Service -StartupType Disabled

<#
 # These break stuff
#>

#Get-Service -DisplayName 'Microsoft Storage Spaces SMP' | Set-Service -StartupType Disabled # Breaks WMI/MSFT Namespace

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"