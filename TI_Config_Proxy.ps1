<#
 # Date: 5/17/2019
 # Reference: ITOPS_PC-231
#>

Invoke-Command {reg load HKU\Default_User C:\Users\Default\NTUSER.DAT}
Set-ItemProperty -Path Registry::'HKey_Users\Default_User\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoConfigURL -Value 'http://proxyconfig.itg.ti.com/proxy.pac'
Invoke-Command {reg unload HKU\Default_User}

<#
 # Change Request:
 # Date:
#>

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"