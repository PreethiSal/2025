###############################################################
######           Lenovo Encryption options               ######
######             launched from runonce                 ######
###############################################################
##  v1 - initial setup 
##  v2 - removed checkpoint steps. updated decryption logic
##  
###############################################################
## lines to update on each release: 
##    application version for checkpoint and location
###############################################################
##  
##
#Param([string]$encryptApp)
#######################################################
######  Function to Check log  ######
#######################################################
function Check-Log {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' })]
        [string]$Path,
        [string]$FindStr
    )
    try {
        $logContent = Get-Content -Path $Path -Raw -ErrorAction Stop

        if ($logContent -match [regex]::Escape($FindStr)) {
            return "Success"
        }
        else {
            return "Failure to find pass string"
        }
    }
    catch {
        return "Failure running try/catch"
    }
}

#######################################################
######  Function - END LOCAL LOGS  ######
#######################################################
function EndLogs {
    $Stopwatch.Stop()
    $Stopwatch.Elapsed
    Write-Host "$currenttime End of script"
    write-host "------------------------"  
    Stop-Transcript
}

#######################################################
######  Function - enableBitlocker  ######
#######################################################
function enableBitlocker() {
    gpupdate /force
    #### check for TPM module present 
    write-host "checking for TPM module present"
    $tpm = (Get-Tpm).TpmPresent
    if (!$tpm) {
        write-host "  get-tpm failed, verifying via WMI"
        $checkTPMwmi = Get-CimInstance -Namespace ROOT\CIMV2\Security\MicrosoftTpm -ClassName win32_TPM -Filter "IsEnabled_InitialValue = 'True'"
        if (!$checkTPMwmi) {
            Write-Host "  This system is not TPM enabled, nothing more to do"
            #return 
        }
        else {
            write-host "passed TPM check via WMI"
        }
    }
    else {
        write-host "passed TPM check"
    }
    ####  check if bitlocker GPO present for computer and enabled ####
    write-host "checking if GPO is present for computer and enabled"
    $GPOnameFilter = 'bitlocker'
    $GPOnamespace = 'ROOT\RSOP\Computer'
    $checkBitlockerGPO = Get-CimInstance -Namespace $GPOnamespace -ClassName "RSOP_GPO" -Filter "name LIKE '%$GPOnameFilter%'"
    if (!$checkBitlockerGPO) {
        write-host "  no GPO named like `'*$GPOnameFilter*`' exists"
        #return
    }
    else {
        write-host "  passed - GPO named: $($checkBitlockerGPO.name)"
    }
    ##### volume status check #####
    write-host "checking if VolumeStatus equals `'FullyDecrypted`'"
    try {
        $volumeStatus = (Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop)
    }
    catch {
        write-host "  get-bitlockvolume cmdlet issue: " $($_.Exception.Message)
    }
    $volumeStatus = (Get-BitLockerVolume -MountPoint $env:SystemDrive)

    if ($volumeStatus.VolumeStatus -eq "FullyDecrypted") {
        write-host "  passed VolumeStatus check"
    }
    elseif ($volumeStatus.EncryptionMethod -eq "XtsAes128" -or $volumeStatus.VolumeStatus -eq "DecryptionInProgress") {
        ## EncryptionMethod -like XtsAes128  then this is not TI GPO and needs to be decrypted
        if ($volumeStatus.EncryptionMethod -eq "XtsAes128") {
            Write-Host "....ready to decrypt... "
            manage-bde $env:SystemDrive -off
            Start-Sleep -seconds 2 
            Write-Host "   "(get-bitlockervolume -mountpoint $env:sysdrive).VolumeStatus 
        }     
        write-host "  decryption is in process, waiting for completion"
        while ($volumeStatus.VolumeStatus -ne "FullyDecrypted") {
            $volumeStatus = (Get-BitLockerVolume -MountPoint $env:SystemDrive)
            Write-Host "  EncryptionPercent: $($volumeStatus.EncryptionPercentage)%"
            Start-Sleep 30
        }
        write-host "  decryption completed"
        #}
    }
    else {
        write-host "  stopping script. VolumeStatus is `'$($volumeStatus.VolumeStatus)`'"
        #return
    }
    #	"FullyDecrypted"
    #   "FullyEncrypted"
    #   "EncryptionInProgress"
    #   "DecryptionInProgress"
    #   "EncryptionPaused"
    #   "DecryptionPaused"
    #
    #### enable bitlocker   ######
    write-host "enabling bitlocker"
    Initialize-Tpm -AllowClear -AllowPhysicalPresence
    Start-Sleep -Seconds 10
    try {
        Write-Host "Encrypting drive with bitlocker"
        Invoke-Command { Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector }
        Start-Sleep -Seconds 10
        Write-Host "Drive Encrypted successfully"
    }
    catch {
        Write-Host "Error in encrypting drive with following message`n$($_.Exception.Message)"
    }
    $volume = (Get-BitLockerVolume -MountPoint $env:SystemDrive)
    try {
        Write-Host "Setting Bitlocker key into AD"
        Invoke-Command { Backup-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $volume.KeyProtector[0].KeyProtectorId } 
        Start-Sleep -Seconds 10
        Write-Host "Bitlocker details are updated in AD Successfully"
    }
    catch {
        Write-Host "Bitlocker updation in AD failed with the following message`n$($_.Exception.Message)"
    }
    try {
        Write-Host "Enabling bitlocker"
        Invoke-Command { Enable-BitLocker -MountPoint $env:SystemDrive -EncryptionMethod XtsAes256 -TpmProtector -WarningAction SilentlyContinue | Resume-BitLocker }
        Start-Sleep -Seconds 10
        Write-Host "Bitlocker enabled successfully"
    }
    catch {
        Write-Host "Bitlocker enabling failed with the following message`n$($_.Exception.Message)"
    }

    write-host "end of enable bitlocker script"
    write-host "Key Protector:"
    $details = (Get-BitLockerVolume -MountPoint $env:SystemDrive).KeyProtector
    Write-Host $details
}

if (Test-Path -Path "C:\ProgramData\TILogs\baseline\encryptionLenovo.log") {
    $output = Check-Log -Path "C:\ProgramData\TILogs\baseline\encryptionLenovo.log" -FindStr "Bitlocker enabled successfully"
    if ($output -eq "Success") {
        #######################################################
        ######  Registry for Bitlocker Encryption  ######
        #######################################################
        try {
            if (!(Test-Path "HKLM:\Software\TI")) {
                Write-Host "Creating new registry path for bitlocker"
                New-Item -Path "HKLM:\Software\TI" -Force | Out-Null
                Write-Host "Registry path successfully created"
            }
        }
        catch {
            Write-Host "Error in creating registry path for bitlocker"
        }

        try {
            Set-ItemProperty -Path "HKLM:\Software\TI" -Name "BitlockerEncryptionStatus" -Value "FullyEncrypted"
        }
        catch {
            Write-Host "Error in updating registry property for bitlocker"
        }
        #######################################################

        #######################################################
        ######  Disabling Bitlocker Task Scheduler  ######
        #######################################################
        try {
            Write-Host "Disabling the task scheduler after bitlocker encryption"
            Get-ScheduledTask -TaskName "baselineFinish_lenovoEncryption" | Disable-ScheduledTask
            Write-Host "Disabled bitlocker scheduled task"
        }
        catch {
            Write-Host "Error in Disabling bitlocker scheduled task"
        }
        #######################################################  
    }
    else {
        #######################################################
        ######  Registry for Bitlocker Encryption  ######
        #######################################################
        try {
            if (!(Test-Path "HKLM:\Software\TI")) {
                Write-Host "Creating new registry path for bitlocker"
                New-Item -Path "HKLM:\Software\TI" -Force | Out-Null
                Write-Host "Registry path successfully created"
            }
        }
        catch {
            Write-Host "Error in creating registry path for bitlocker"
        }

        try {
            Set-ItemProperty -Path "HKLM:\Software\TI" -Name "BitlockerEncryptionStatus" -Value "NotEncrypted"
        }
        catch {
            Write-Host "Error in updating registry property for bitlocker"
        }
        #######################################################
    }
}
else {
    #######################################################
    ######  START LOCAL LOGS  ######
    #######################################################
    $logpath = "C:\ProgramData\TILogs\baseline"
    $logname = "encryptionLenovo.log"   
    If (Test-Path $logpath) {
        Start-Transcript -Path $logpath\$logname -Append
        Write-Output $logpath" exists. Skipping creating new dir." 
    }
    Else {
        New-Item -Path $logpath -ItemType Directory | Out-Null
        Start-Transcript -Path $logpath\$logname -Append
        Write-Output "The folder $logpath doesn't exist. Creating now." 
    }
    $stopwatch = [System.Diagnostics.Stopwatch]::new()
    $Stopwatch.Start()

    write-host "run function enableBitlocker"
    enableBitlocker
}


#######################################################
######  END LOCAL LOGS  ######
#######################################################
EndLogs
