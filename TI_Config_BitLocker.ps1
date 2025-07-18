<# Enable BitLocker in MDT/OSD
 # Author: Fernando Elizondo
 # Company: TSP
 # Date Created: 10/24/2018
 #  
#>

$stopWatch = [system.diagnostics.stopwatch]::startNew()
$machineToVerify = $env:COMPUTERNAME

function localLogs
{
    $monthDayYear = (Get-Date).toString(‘MM-dd-yyyy-HH.mm.ss’)  
    $logpath = "C:\ProgramData\TILogs\Provisioning"
    $logname = "$($monthDayYear)_MDT_Bitlocker.txt"   
    If (Test-Path $logpath) {
        Start-Transcript -Path $logpath\$logname # -Append
        #Write-Host $logpath" exists. Skipping creating new dir."
    }
    Else {
        New-Item -Path $logpath -ItemType Directory | Out-Null
        Start-Transcript -Path $logpath\$logname # -Append
        Write-Host "The folder $logpath didn't exist. Created new folder."
    }
    Write-Host "`r`n"
}

localLogs

Write-Host "** ping central logging server"
#Test-Connection lewv0469.ent.ti.com -Count 1 
(Test-Connection lewv0469.ent.ti.com -Count 1).ResponseTime
Write-Host "`r`n"


Write-Host "** run bitlocker enable and backup key to ad commands"
Invoke-Command {Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector}
$volume = (Get-BitLockerVolume -MountPoint $env:SystemDrive)
Invoke-Command {Backup-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $volume.KeyProtector[0] -ErrorAction SilentlyContinue | Out-Null}
(Get-BitLockerVolume -MountPoint $env:SystemDrive).KeyProtector > "\\lewv0469.ent.ti.com\LOGS\$env:Computername\$env:ComputerName.txt"
Start-Sleep -Seconds 10
Invoke-Command {Enable-BitLocker -MountPoint $env:SystemDrive -EncryptionMethod XtsAes256 -TpmProtector -WarningAction SilentlyContinue | Resume-BitLocker}


$stopWatch.Stop()
Write-Host "END *****  total runtime: $($stopWatch.Elapsed.Minutes) minute(s) and $($stopWatch.Elapsed.Seconds) seconds -- $($stopWatch.Elapsed.TotalMilliseconds) ms"

Stop-Transcript


<# 
 # Reviewed By: 
 # Reviewed Date:
 # Review Comments:

 # Modified By: Fernando Elizondo
 # Modified Date: 10/25/2018
 # Modified Comments: Removed pipe-to Add-BitlockerRecoveryKey and set -RecoveryPasswordProtector paramter in Enable-BitLocker.
 Added ability to backup the keys to AD, but need to add the unit to the domain first.

 # Modified By: Fernando Elizondo
 # Modified Date: 11/5/2018
 # Modified Comments: Added ErrorAction and Out-Null to last line of script.
  
 # Modified By: Fernando Elizondo
 # Modified Date: 11/7/2018
 # Modified Comments: removed .KeyProtectorID from the -KeyProtectorID parameter string & changed -EncryptionMethod to XtsAES256

 # Modified By: Fernando Elizondo
 # Modified Date: 11/15/2018
 # Modified Comments: added 2nd text backup location and 10 second runoff to ensure keys are backed up to AD prior to encryption--matching the GPO setting.
 
 # Modified By: Fernando Elizondo
 # Modified Date: 12/4/2018
 # Modified Comments: removed 2nd txt backup due to permissions issues. Changed primary text location to the new server log location.
 
 # Modified By: TJ Brennan
 # Modified Date: 12/7/2020
 # Modified Comments: updated server path to fqdn. added local machine logging
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