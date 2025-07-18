<#
 # Author: TJ Brennan
 # Company: Texas Instrument, Inc.
 # Date Copied: 10/18/2018
 # Source: configure.ps1
 # Source Location: \\lewv0114.itg.ti.com\e$\inet\wwwroot\poc\scripts
#>

$appsToRemove = @(
	'*.office.*'
	'Microsoft.SkypeApp'
	'*.xbox*'
)
foreach($app in $appsToRemove){
	#Get-AppxPackage -name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
	Get-AppxProvisionedPackage -Online | Where-Object displayName -like $app | Remove-AppxProvisionedPackage -Online  -ErrorAction SilentlyContinue | Out-Null

<#
 # Date Reviewed:
 # Reviewed By:

 # Date Modified: 7/26/2018
 # Modified By: TJ Brennan

 # Change request:
#>
}

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"