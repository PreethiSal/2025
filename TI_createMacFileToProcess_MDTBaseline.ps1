#######################################################
######  createMacFileToProcess_MDTBaseline.ps1	 ######
#######################################################
## script to create <machineName>.log files on central server containing MAC address that will be processed by baseline script

##	tj brennan	tj.brennan@ti.com
##	1.1		March 25, 2020	-- add logging to local machine for troubleshooting
##							-- added try/catch to command where file is copied to central server
##							-- added stopwatch
##							-- changed $shareLoc to fqdn
##	1.2		March 26, 2020	-- added user and password variables from task sequence env
##							-- added mapping drive and changed writing the file to the server to use Set-Content so that credentials could be used
##  1.3     Feb, 2021       -- change Get-NetAdapter to '$_.name -like "Wi-Fi"'

$stopWatch = [system.diagnostics.stopwatch]::startNew()
#######################################################
######  START LOCAL LOGS  ######
#######################################################
$logpath = "C:\ProgramData\TILogs\Provisioning"
$logname = "updateADscript.txt"   
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
######  VARIABLES  ######
#######################################################
Write-Host "## Creating variables " 
$machineToVerify = $env:COMPUTERNAME
$shareLoc = "\\lewvw10prov1.ent.ti.com\MACupdate"
$targetDir = "newMDT" ## "testAccount" 
$provClearShare = Join-Path $shareLoc $targetDir
$newFile = "$machineToVerify.log"
$provClearFullPath = Join-Path $provClearShare $newFile

Write-Host "provClearFullPath = " $provClearFullPath 
Write-Host "`r`n"

<## new changes
    function ConvertFrom-Base64($stringfrom) { 
       $bytesfrom  = [System.Convert]::FromBase64String($stringfrom); 
       $decodedfrom = [System.Text.Encoding]::UTF8.GetString($bytesfrom); 
        return $decodedfrom   
    }
    # Grab the variables from the Task Sequence
    $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    $tsenv.GetVariables() | % { Set-Variable -Name "$_" -Value "$($tsenv.Value($_))" }
    #Set Credentials to Task Sequence variable values
    $ClearID = ConvertFrom-Base64 -stringfrom "$UserID"
    $ClearPass = ConvertFrom-Base64 -stringfrom "$UserPassword"
    $EndUserEmpID = $ClearID

	$username = $clearID
	$password = ConvertTo-SecureString $ClearPass -AsPlainText -Force
	$cred = New-Object Management.Automation.PSCredential ($username, $password)
	#>

	$drive = New-PSDrive -Name T -PSProvider FileSystem -Root $provClearShare -Persist 



## end of new changes

#######################################################
######  CREATE <MACHINENAME>.LOG 		######
#######################################################
Write-Host "## Creating .log file on central server "
try{	
#	(Get-NetAdapter | ? {$_.InterfaceDescription -notlike "*virtual*" } -ErrorAction Continue).MacAddress -replace "\-","" > $provClearFullPath
#	$fileContentsToCopyToServer = (Get-NetAdapter | ? {$_.InterfaceDescription -notlike "*virtual*" } -ErrorAction Continue).MacAddress -replace "\-",""
	$fileContentsToCopyToServer = (Get-NetAdapter | ? {$_.name -like "Wi-Fi*" } -ErrorAction Continue).MacAddress -replace "\-",""
 #   $wificheck = (Get-NetAdapter | ? {$_.name -like "Wi-Fi" }).MacAddress -replace "\-","" | out-file -filepath $provClearFullPath
	Set-Content -Path T:\$newFile -Value $fileContentsToCopyToServer
	Write-Host "SUCCESSFUL! " 
} catch {Write-Warning "Failed to create log file - $($_.Exception.Message)" }

Write-Host "`r`n"

	$drive | Remove-PSDrive -Force

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