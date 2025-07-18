<#
 # Date: 9/22/2022 TJ Brennan
 # Reference: ITOPS_PC-231
 # 9/22/22	v2	added line "ProxyEnable -value 0" to uncheck the box for auto detect settings
#>

Invoke-Command {reg load HKU\Default_User C:\Users\Default\NTUSER.DAT}
Set-ItemProperty -Path Registry::'HKey_Users\Default_User\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoConfigURL -Value 'http://proxyconfig.itg.ti.com/proxy.pac'
Set-ItemProperty -Path Registry::'HKey_Users\Default_User\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoDetect -value 0 -ErrorAction Stop

Invoke-Command {reg unload HKU\Default_User}

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"