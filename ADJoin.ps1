<#
.SYNOPSIS  
    This will join the computer to the AD domain ENT.TI.COM


.DESCRIPTION
    This script will join to the domain, should be run on endpoint
    The computer account should have been created with the following cmd already for this to work


    New-ADComputer -Server <DC name> -Credential $cred -Name <comp name> -SAMAccountName <comp name> -Path $adOU -Enabled $true -AccountPassword (ConvertTo-SecureString -String 'TempJoinPA$$' -AsPlainText -Force)
    -OtherAttributes @{'tiPerDeviceType'=$attr_tiPerDeviceType;'tiPerWLNetAZ'=$attr_tiPerWLNetAZ;'tiPerWRNetAZ'=$attr_tiPerWRNetAZ;'tiPerHostMac'=@($attr_tiPerHostMac)}        


.NOTES  
    Author        : Prakash Prabhakar (prakashbp@ti.com)
    Version       : 1.0.0.0 Initial Build 
    Creation Date : 26Jan2019
    Purpose       : To join Windows client to ENT domain as part of baseline install
    Script Name   : Join-Domain.ps1


.EXAMPLE
    Join-Domain.ps1
    
#>


#Log path
$logpath = "C:\ProgramData\TILogs\ADMACWinicon"
$logname = "ADJoin.log"   
If (Test-Path $logpath) {
    Start-Transcript -Path $logpath\$logname -force
    Write-Output $logpath" exists. Skipping creating new dir." 
}
Else {
    New-Item -Path $logpath -ItemType Directory | Out-Null
    Start-Transcript -Path $logpath\$logname -force
    Write-Output "The folder $logpath doesn't exist. Creating now." 
}
  
#=================== Main Code =============================


$ErrorActionPreference = "SilentlyContinue"
$global:currenttime = Set-PSBreakpoint -Variable currenttime -Mode Read -Action { $global:currenttime = Get-Date }
#Start-Log $PSCommandPath
write-host "$currenttime Started --- $PSCommandPath"


# Check for administrative rights. if not, runas admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}



######  variables  ######
[string]$ADdomain = "ent.ti.com"
[string]$dnsSuffix = "dhcp.ti.com"


# set reg for DNS suffix
# Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "Domain" -Value $dnsSuffix -Force
# Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "NV Domain" -Value $dnsSuffix -Force
# # uncheck box for "Change primary DNS suffix when domain membership changes"
# Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\" -Name "SyncDomainWithMembership" -Value '0' -Force


# join to the AD domain
$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
        UserName = $null
        Password = (ConvertTo-SecureString -String 'TempJoinPA$$' -AsPlainText -Force)[0]
    })


Try {
    $objReturn = Add-Computer -Domain $ADdomain -PassThru -Options UnsecuredJoin, PasswordPass -Credential $joinCred -ErrorAction Stop
}
Catch { Write-Host $($_.Exception.Message) }


If ($objReturn.HasSucceeded) { Write-Host "$currenttime $env:COMPUTERNAME - reboot to complete" }


Write-host "$currenttime Ended --- $PSCommandPath"

Stop-Transcript