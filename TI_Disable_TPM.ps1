<#
 # Author: Greg Speer
 # Company: TI
 # Date Created: 3/04/2019
#>

Disable-TpmAutoProvisioning

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