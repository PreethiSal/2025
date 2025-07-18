<#
 # Author: Fernando Elizondo
 # Company: TSP
 # Date Created: 10/18/2018
#>

Get-ScheduledTask -TaskPath \Microsoft\Windows\Maps\* | Disable-ScheduledTask

Get-ScheduledTask -TaskPath '\Microsoft\Windows\Windows Media Sharing\*' | Disable-ScheduledTask

Get-ScheduledTask -TaskPath '\Microsoft\Windows\Workplace Join\*' | Disable-ScheduledTask

Get-ScheduledTask -TaskPath \Microsoft\Windows\UPnP\* | Disable-ScheduledTask

Get-ScheduledTask -TaskPath \Microsoft\XblGameSave\* | Disable-ScheduledTask

<#
 # Date Reviewed:
 # Reviewed By:

 # Date Modified:
 # Modified By:

 # Change request:
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