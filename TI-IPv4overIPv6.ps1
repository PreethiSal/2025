#######################################################
######  TI-IPv4overIPv6.ps1	 ######
#######################################################
## script to prioritize IPv4 over IPv6

##	tj brennan	tj.brennan@ti.com
##	1.0		May 25, 2022	-- initial script
##	
##	
##	
##	
##	
##	
##	

$stopWatch = [system.diagnostics.stopwatch]::startNew()
#######################################################
######  START LOCAL LOGS  ######
#######################################################
$logpath = "C:\ProgramData\TILogs\Provisioning"
$logname = "TI-IPv4overIPv6.txt"   
If (Test-Path $logpath) {
    Start-Transcript -Path $logpath\$logname -Append
   # Write-Host $logpath" exists. Skipping creating new dir."
}
Else {
    New-Item -Path $logpath -ItemType Directory | Out-Null
    Start-Transcript -Path $logpath\$logname -Append
    Write-Host "The folder $logpath didn't exist. Created new folder."
}
Write-Host "`r`n"

#######################################################
######       set registry key       ######
#######################################################
Write-Host "updating registry key " 

# REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d "32" /f
Set-ItemProperty "HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters\" -Name "DisabledComponents" -type dword -Value '32' -Force

$stopWatch.Stop()
#$stopWatch.Elapsed.TotalSeconds 
Write-Host "END *****  total runtime: $($stopWatch.Elapsed.Minutes) minute(s) and $($stopWatch.Elapsed.Seconds) seconds -- $($stopWatch.Elapsed.TotalMilliseconds) ms"

Stop-Transcript

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"