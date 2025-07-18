<#
 # Author: Fernando Elizondo
 # Company: TSP
 # Date Created: 8/18/2018
#>

Copy-Item -Path 'C:\Windows\Temp\Applications\Dell CU 2.4\policy.xml' -Destination 'C:\Program Files (x86)\Dell\CommandUpdate\policy.xml'
Start-Sleep 5
New-Item -Path 'C:\ProgramData\Dell\CommandUpdate' -ItemType Directory
Start-Sleep 5
New-Item -Path 'C:\ProgramData\Dell\CommandUpdate' -ItemType File -Name RunDCU_2x.cmd -Value "START 'C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe' /log c:\ProgramData\Dell\DCU.log /silent"

<#
 # Date Reviewed:
 # Reviewed By:

 # Date Modified:2/15/2019
 # Modified By:Fernando Elizondo
 # Comments: Corrected path

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