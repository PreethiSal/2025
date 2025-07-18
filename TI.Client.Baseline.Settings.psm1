<#  
.SYNOPSIS  
    All Windows client baseline settings are creating as reusable functions in this script/module

.DESCRIPTION
    This is the collection of all Windows client baseline seetings as functions/cmdlets that could 
    be used in any deployment process by importing this module/script.
    This script/module will provide following functions/cmdlets:
        Disable-AutoSleep            (will disable all auto sleep to avoid entering sleep mode during the build)
        Enable-BalancedPowerScheme   (will reset the Balanced power scheme to factory defaults and apply)
        Apply-MandatoryPowerSettings (these are some of the power related setting from ITsec)
        Apply-ServicesSetting        (this will disable, set to auto / manual list of services)
        Start-Log $PSCommandPath     (This will capture baseline logs)
        Disable-OOTBTasks            (This will disable out-of-the-box scheduled tasks that are not needed)
        Remove-OOTBApps              (This will remove out-of-the-box apps provisioned/installed that are not needed)
        Stamp-Baseline Web/MDT/OSD/vbox   (This will update the registry with install method and baseline version)
        Disable-ContentDeliveryManager       (This will update reg to disable appsuggestion, ootb bloatware like candy crus, and adverts for users)
        Disable-ActivityHistory	        - To disable the Timeline, and stop sending users' activity history to Microsoft's servers.
        Disable-AdvertisingID	        - This will disable Windows 10 creating unique advertising ID for each user  to learn and target ads
        Disable-BackroundAccessApps	- Disable Background application access - ie. apps can't download or update when they aren't used
        Disable-ErrorReporting	        - Disable sending error reports to MS
        Disable-Feedback	        - Disable Feedback prompts, and sending feedback to MS
        Disable-FileExplorerAds	        - Disable MS pushing Ads in File Explorer
        Disable-IEFirstRun	        - Disable IE First run Wizard
        Disable-LocationTracking	- Disable device location tracking built-in feature 
        Disable-MapUpdates	        - Disable automatic Maps updates
        Disable-PenWorkspaceAppSuggestions	- Disable Windows Ink Workspace app suggestions Ads
        Disable-SmartScreen		- Disable SmartScreen Filter sending browsing/download data to MS
        Disable-SpynetAutomaticSampleSubmission	- Disable spynet sending auto reports to MS
        Disable-TailoredExperiences	- Disable system sending diagnostic data to MS to provide personalized recommendations, tips and offers to tailor Windows for the user's needs,
        Disable-Telemetry		- Disable system sending technical data about the how the Windows devices and its related software is working and send this data periodically to MS
        Disable-WiFiSense		- Disable sharing your passkeys with your contacts to allow them to connect to your wireless network.
        Disable-AutoInstallNWDevices	- Disable automatic install of network devices
        Disable-Autorun			- Disable automatic start of programs from addon media

.EXAMPLE
    The following is an example of importing the Client baseline Powershell Script module and running "disable-AutoSleep" to disable automatic sleep on Windows computer.
        Import-Module -DisableNameChecking -Global .\TI.Client.Baseline.Settings.psm1
        Disable-AutoSleep 

.NOTES  
    Author        : Prakash Prabhakar (prakashbp@ti.com)
    Version       : 1.0.0.0 Initial Build 
    Creation Date : 27Feb2019
    Purpose       : To re-use baseline scripts in all deployment processes
#>

# Version number of this module.
$ModuleVersion = '1.0.0.1' 
$ErrorActionPreference = 'SilentlyContinue'


Function Disable-AutoSleep {
    # This may be needed during the baseline install, and will revert back to balanced power 
     
    powercfg.exe -x -monitor-timeout-ac 0
    powercfg.exe -x -monitor-timeout-dc 0
    powercfg.exe -x -disk-timeout-ac 0
    powercfg.exe -x -disk-timeout-dc 0
    powercfg.exe -x -standby-timeout-ac 0
    powercfg.exe -x -standby-timeout-dc 0
    powercfg.exe -x -hibernate-timeout-ac 0
    powercfg.exe -x -hibernate-timeout-dc 0
    Write-Host "Disabled AutoSleep"
}


Function Enable-BalancedPowerScheme {
    #This will set reset the power sheme values to factory defaults and then set the power scheme to balanced

    powercfg.exe -restoredefaultschemes
    powercfg.exe /s SCHEME_BALANCED
    Write-Host "Enabled default Balanced power scheme" 
}

Function Apply-MandatoryPowerSettings {
    # These are mandated by ITsec

    powercfg.exe -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 100
    powercfg.exe -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 100
    powercfg.exe -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 100
    powercfg.exe -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 100
    powercfg.exe -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 100
    powercfg.exe -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 100
    powercfg.exe -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 20
    powercfg.exe -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 20
    powercfg.exe -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 20
    powercfg.exe -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 20
    powercfg.exe -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 20
    powercfg.exe -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 20
    powercfg.exe -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 15
    powercfg.exe -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 15
    powercfg.exe -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 15
    powercfg.exe -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 15
    powercfg.exe -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 15
    powercfg.exe -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 15
    powercfg.exe -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 10
    powercfg.exe -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 10
    powercfg.exe -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 10
    powercfg.exe -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 10
    powercfg.exe -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 10
    powercfg.exe -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 10
    powercfg.exe -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
    powercfg.exe -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
    powercfg.exe -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
    powercfg.exe -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
    powercfg.exe -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
    powercfg.exe -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
    powercfg.exe -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
    powercfg.exe -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
    powercfg.exe -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
    powercfg.exe -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
    powercfg.exe -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
    powercfg.exe -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
    Write-Host "Applied mandatory power settings"
}


Function Apply-ServicesSetting {
        
    $ServicesToAutoStart =@(
                            'Remote Registry'
                            'WebClient'
                            'Windows Update'

    )

    $ServicesToDisable =@(
                            'AllJoyn Router Service'
                            'Application Layer Gateway Service'
                            'Device Management Enrollment Service'
                            'Downloaded Maps Manager'
                            'Encrypting File System (EFS)'
                            'Fax'
                            'Function Discovery Provider Host'
                            'Function Discovery Resource Publication'
                            'Internet Connection Sharing (ICS)'
                            'Link-Layer Topology Discovery Mapper'
                            'Microsoft Account Sign-in Assistant'
                            'Microsoft Windows SMS Router Service.'
                            'Network Connectivity Assistant'
                            'Payments and NFC/SE Manager'
                            'Peer Name Resolution Protocol'
                            'Peer Networking Grouping'
                            'Peer Networking Identity Manager'
                            'Phone Service'
                            'PNRP Machine Name Publication Service'
                            'Retail Demo Service'
                            'Routing and Remote Access'
                            'Shared PC Account Manager'
                            'SNMP Trap'
                            'SSDP Discovery'
                            'Telephony'
                            'UPnP Device Host'
                            'WalletService'
                            'Windows Media Player Network Sharing Service'
                            'Windows Mobile Hotspot Service'
                            'Xbox Live Auth Manager'
                            'Xbox Live Game Save'
                            'Xbox Live Networking Service'

    )

    $ServicesToManual =@(
                            'System Event Notification Service'

    )

    Foreach ($Service in $ServicesToAutoStart) {
        Try {
            Get-Service -DisplayName $Service -ErrorAction Stop | Set-Service -StartupType Automatic
            Write-Host "$Service - set to Automatic"
        } Catch { Write-Warning "Exception Message: $($_.Exception.Message)" }
    }

    Foreach ($Service in $ServicesToDisable) {
        Try {
            Get-Service -DisplayName $Service -ErrorAction Stop | Set-Service -StartupType Disabled
            Write-Host "$Service - disabled"
        } Catch { Write-Warning "Exception Message: $($_.Exception.Message)" }
    }

    Foreach ($Service in $ServicesToDisable) {
        Try {
            Get-Service -DisplayName $Service -ErrorAction Stop | Set-Service -StartupType Manual
            Write-Host "$Service - set to Manual"
        } Catch { Write-Warning "Exception Message: $($_.Exception.Message)" }

    }

}

Function Start-Log ($PassPSCommandPath) {
    # Run this function to start transcript log
    # Start-Log $PSCommandPath
    
    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript -ErrorAction SilentlyContinue 2>&1 | out-null
    $timestamp = $(((get-date).ToUniversalTime()).ToString("yyyyMMddhhmmssff"))
    $LogRoot = "C:\BaselineLogs"  
    If(!(test-path $LogRoot)) { New-Item -ItemType Directory -Force -Path $LogRoot } # create if not exists
    #If ($PassPSCommandPath -eq "") { $ScriptName = $MyInvocation.MyCommand.Name }
    $ScriptName = Split-Path $PassPSCommandPath -Leaf
    $global:TranscriptFile = "$LogRoot\$ScriptName.$timestamp.log"
    start-transcript -path $TranscriptFile 2>&1 | out-null
    write-host $PassPSCommandPath
}

Function Disable-OOTBTasks {
    # This disables out-of-the-box scheduled tasks that are not needed

    $TasksToDisable =@(
                        'OneDrive*'
                        'AD RMS Rights Policy Template Management (Automated)'
                        'PolicyConverter'
                        'VerifiedPublisherCertStoreCheck'
                        'Microsoft Compatibility Appraiser'
                        'ProgramDataUpdater'
                        'StartupAppTask'
                        'Pre-staged app cleanup'
                        'Proxy'
                        'UninstallDeviceTask'
                        'License Validation'
                        'Consolidator'
                        'UsbCeip'
                        'Microsoft-Windows-DiskDiagnosticDataCollector'
                        'Microsoft-Windows-DiskDiagnosticResolver'
                        'Property Definition Sync'
                        'WakeUpAndContinueUpdates'
                        'WakeUpAndScanForUpdates'
                        'Notifications'
                        'WindowsActionDialog'
                        'WinSAT'
                        'MapsToastTask'
                        'MapsUpdateTask'
                        'MNO Metadata Parser'
                        'LPRemove'
                        'GatherNetworkInfo'
                        'Background Synchronization'
                        'Logon Synchronization'
                        'Sysprep Generalize Drivers'
                        'LoginCheck'
                        'MobilityManager'
                        'Account Cleanup'
                        'FamilySafetyMonitor'
                        'FamilySafetyRefreshTask'
                        'SvcRestartTaskLogon'
                        'SvcRestartTaskNetwork'
                        'Storage Tiers Optimization'
                        'LicenseAcquisition'
                        'HybridDriveCachePrepopulate'
                        'HybridDriveCacheRebalance'
                        'RunUpdateNotificationMgr'
                        'UPnPHostConfig'
                        'HiveUploadTask'
                        'PerformRemediation'
                        'BfeOnServiceStartTypeChange'
                        'UpdateLibrary'
                        'WIM-Hash-Validation'
                        'Automatic-Device-Join'
                        'Recovery-Check'
                        'XblGameSaveTask'
                        'SvcRestartTask'


    )

    Foreach ($Task in $TasksToDisable) {
        Try {
            Get-ScheduledTask -TaskName $Task -ErrorAction Stop | Disable-ScheduledTask -ErrorAction Stop |Out-Null
            Write-Host "$Task - Disabled"
        } Catch { Write-Warning "$Task - $($_.Exception.Message)" }

    }
}

Function Remove-OOTBApps {
    #Remove installed apps
    #Remove provisioned app

    $AppsToRemove =@(
                    'Microsoft.BingWeather'
                    'Microsoft.DesktopAppInstaller'
                    'Microsoft.Messaging'
                    'Microsoft.MicrosoftOfficeHub'
                    'Microsoft.MicrosoftSolitaireCollection'
                    'Microsoft.MixedReality.Portal'
                    'Microsoft.Office.OneNote'
                    'Microsoft.OneConnect'
                    'Microsoft.People'
                    'Microsoft.SkypeApp'
                    'Microsoft.StorePurchaseApp'
                    'Microsoft.VP9VideoExtensions'
                    'Microsoft.Wallet'
                    'Microsoft.Windows.Photos'
                    'Microsoft.WindowsAlarms'
                    'Microsoft.WindowsCamera'
                    'microsoft.windowscommunicationsapps'
                    'Microsoft.WindowsFeedbackHub'
                    'Microsoft.WindowsMaps'
                    'Microsoft.WindowsStore'
                    'Microsoft.Xbox.TCUI'
                    'Microsoft.XboxApp'
                    'Microsoft.XboxGameOverlay'
                    'Microsoft.XboxGamingOverlay'
                    'Microsoft.XboxIdentityProvider'
                    'Microsoft.XboxSpeechToTextOverlay'
                    'Microsoft.YourPhone'
                    'Microsoft.ZuneMusic'
                    'Microsoft.ZuneVideo'

    )

    Foreach ($App in $AppsToRemove) {
        Try {
            Remove-AppxProvisionedPackage -Online -PackageName ((Get-AppxProvisionedPackage -Online | ? { $_.DisplayName -eq $app }).PackageName) | Out-Null
            Get-AppxPackage | ? {$_.Name -eq $app } | Remove-AppxPackage | Out-Null
            Write-Host "$App - Removed"
        } Catch { Write-Warning "$App - $($_.Exception.Message)" }
    }
    #Remove MS Onedrive
    Try {
	    Start-Process -Wait -FilePath "%SystemRoot%\SysWOW64\OneDriveSetup.exe" -ArgumentList '/uninstall' -ErrorAction Stop
    } Catch {Write-Warning "Microsoft.OneDrive - $($_.Exception.Message)"}

}

Function Test-RegistryValue {
    # This will check if the reg name exists
    param (
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Path,
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Value
    )

    try {
        $result = Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop
        If ( $result -eq $null) { return $false } # looks like a bug, does not error when value does not exist.. I had to use If/else to complete the logic
        Else { return $true }
    } catch {return $false }
}

Function Stamp-Baseline {
    # This will update the reg with baseline details and method used for future reference

    Param( 
        [parameter(Mandatory=$true)]
        [ValidateSet(“Web”,”MDT”,”OSD”,"vBox")] 
        [String] 
        $InstallType
    )

    If ($InstallType -eq "Web") { $InstallMethod = "ProvisioningWebsite"}
    If ($InstallType -eq "OSD") { $InstallMethod = "SCCM OSD"}
    If ($InstallType -eq "MDT") { $InstallMethod = "MDT"}
    If ($InstallType -eq "vBox") { $InstallMethod = "vBox Image build"}

    $RegPathBaseline="HKLM:\Software\TI\Baseline"
    $RegPathTI="HKLM:\Software\TI"

    If (!(test-path -Path $RegPathTI)) {New-Item -Path "HKLM:\Software\" -Name "TI"}
    If (!(test-path -Path $RegPathBaseline)) {New-Item -Path "HKLM:\Software\TI" -Name "Baseline"}

    If( !(Test-RegistryValue -Path $RegPathBaseline -Value 'InstallMethod') ) {Set-ItemProperty -path $RegPathBaseline -Name 'InstallMethod' -Value $InstallMethod }
    If( !(Test-RegistryValue -Path $RegPathBaseline -Value 'InstallTime') ) {Set-ItemProperty -path $RegPathBaseline -Name 'InstallTime' -Value $(Get-Date) }
    If( !(Test-RegistryValue -Path $RegPathBaseline -Value 'InitialVersion') ) {Set-ItemProperty -path $RegPathBaseline -Name 'InitialVersion' -Value $((Get-ItemProperty -Path ‘HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion’).ReleaseId +"("+ (Get-WmiObject -class Win32_OperatingSystem).version +")" ) }
    Write-Host "Baseline method and version are updated to the registry"
}

Function Disable-ContentDeliveryManager {
    ## remove ootb bloatware / candy crush / other game adverts to user
    ## disable app suggestions for any new user profile
    ## disable dynamically inserted app tiles for any new user profile
    
    $DisableContentDelivery =@(

                                'ContentDeliveryAllowed'       #Disable Content Delivery
                                'OemPreInstalledAppsEnabled'   #Disable OEM Apps
                                'PreInstalledAppsEnabled'      #Disable Promotional Apps
                                'PreInstalledAppsEverEnabled'  #Disable Promotional Apps
                                'SoftLandingEnabled'           #Disable Windows Tips, Tricks & Suggestions
                                'SystemPaneSuggestionsEnabled' #Disable Suggested Apps in Start Menu
                                'SilentInstalledAppsEnabled'   #Disable Unwanted App Installs
                                'RemediationRequired'          #Disable Unwanted App Installs
                                'SubscribedContentEnabled'     #Disable showing suggested apps
                                'SubscribedContent-310093Enabled' #Disable showing suggested apps
                                'SubscribedContent-338387Enabled'
                                'SubscribedContent-338388Enabled' 
                                'SubscribedContent-338389Enabled' 
                                'SubscribedContent-338393Enabled'
                                'SubscribedContent-353696Enabled'
                                'SubscribedContent-353698Enabled'
                                

    )

    # Load default reg hive
    reg load HKU\Default_User C:\Users\Default\NTUSER.DAT

    Foreach ($item in $DisableContentDelivery ) {
        Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name $item -Type DWord -Value 0
        Set-ItemProperty -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name $item -Type DWord -Value 0
    }

    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
	reg unload HKU\Default_User

    Write-Host "Disabled MS Content Delivery Manager"
}

Function Disable-BackroundAccessApps {
    # Disable Background application access - ie. apps can't download or update when they aren't used
    # Cortana is excluded as its inclusion breaks start menu search, ShellExperience host breaks toast notifications
	
    Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*","Microsoft.Windows.ShellExperienceHost*" | ForEach-Object {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
	}
    
    Write-Output "Disabled Background Applications Access"
}

Function Disable-LocationTracking {
    # Disable Location Tracking
	
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
    Write-Output "Disabled Location Tracking."
}

Function Disable-MapUpdates {
    # Disable automatic Maps updates
	
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
    Write-Output "Disabled automatic Maps updates..."
}

Function Disable-Feedback {
    # Disable Feedback prompts - feedback to MS
	
	If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
		New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    Write-Output "Disabled Feedback."
}

Function Disable-PenWorkspaceAppSuggestions {
    # Disable Windows Ink Workspace app suggestions Ads
   
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" -Name "PenWorkspaceAppSuggestionsEnabled" -Type DWord -Value 0
    Write-Host "Disabled Windows Ink Workspace app suggestions"
}

Function Disable-FileExplorerAds{
    # Disable file explorer advertisements/app sugegstions
    # Ads will be pushed when one drive is enabled... else you may not see them

    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
    Write-Host "Disabled File Explorer advertisements"
}

Function Disable-AdvertisingID {
    # Disable MS Advertising ID
    # MS will create an ID to learn and target ads
    # Windows generates a unique advertising ID for each user on a device, which app developers and advertising networks can then use to provide more relevant advertising in apps. 
    # When the advertising ID is enabled, apps can access and use it in much the same way that websites can access and use a unique identifier stored in a cookie. 
    # Thus, app developers (and the advertising networks they work with) can associate personal data they collect about you with your advertising ID and use that 
    # personal data to provide more relevant advertising and other personalized experiences across their apps.
	
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
    Write-Output "Disabled MS Advertising ID."
}

Function Disable-TailoredExperiences {
    # Disable Tailored Experiences - "Let Microsoft provide more tailored experiences with relevant tips and recommendations by usign your diagnostic data"
	
	If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value 0
    Write-Output "Disabled Tailored Experiences."
}

Function Disable-SpynetAutomaticSampleSubmission {
    #Disable Windows Defender's automatic sample submission  and Spynet community membership

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Type DWord -Value 2
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Type DWord -Value 0
    Write-Host "Disabled Windows Defender's automatic sample submission"
}

Function Disable-ErrorReporting {
    # Disable Error reporting
    # Windows Error Reporting (WER) is a flexible event-based feedback infrastructure designed to gather information about the hardware 
    # and software problems that Windows can detect, report the information to Microsoft, and provide users with any available solutions
    	
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
    Write-Output "Disabled Error reporting."
}

Function Disable-Telemetry {
    # Disable Telemetry
    # This tweak may disables the possibility to join Windows Insider Program, as it requires Telemetry data.
    
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Name "NoGenTicket" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
    Write-Output "Disabled Telemetry."
}

Function Enable-Telemetry {
    # Enable Telemetry
    # This is only to troubleshoot if disabling telemetry has caused any issue
	
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Name "NoGenTicket" -ErrorAction SilentlyContinue
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
	Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
    Write-Output "Enabled Telemetry."
}

Function Disable-WiFiSense {
    # Disable Wi-Fi Sense
    # This was enabled when MS first intruduced, but later disabled. I am setting this to make sure we keep this disabled if MM changes their policy in future releases.
    # Wi-Fi Sense is a feature in Windows 10 that allows you to Share your Wi-Fi connections. 
    # Wi-Fi Sense can connect you to open Wi-Fi hotspots that are collected through crowdsourcing, or to Wi-Fi networks that your contacts share with you through Wi-Fi Sense.
    # Wi-Fi Sense does this by sharing the secret passkeys that your contacts use to connect to the wireless networks, or by sharing your passkeys with your contacts to allow them to connect to your wireless network.
	
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "WiFISenseAllowed" -Type DWord -Value 0
    Write-Output "Disabled Wi-Fi Sense."
}

Function Disable-SmartScreen {
    # Disable SmartScreen Filter
    # The SmartScreen Filter is a security addition to Internet Explorer that warns users if known malicious or dangerous websites are visited.
    # For this, system send mostly all browsing/download data to MS
	
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 0
    Write-Output "Disabled SmartScreen Filter."
}

Function Disable-ActivityHistory {
    # Disable Activity History feed in Task View 
    # To disable the Timeline, and stop if from sending your activity history to Microsoft's servers.
    # The checkbox "Let Windows collect my activities from this PC" remains checked even when the function is disabled
	
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
    Write-Output "Disabled Activity History."
}

Function Disable-AutoInstallNWDevices {
    # Disable automatic installation of network devices
	
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Name "AutoSetup" -Type DWord -Value 0
    Write-Output "Disabled automatic installation of network devices."
}

Function Disable-Autorun {
    # Disable Autorun for all drives
	
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
    Write-Output "Disabled Autorun for all drives."
}

Function Disable-Hibernation {
    # Disable Hibernation
	
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type DWord -Value 0
	powercfg /HIBERNATE OFF 2>&1 | Out-Null
    Write-Output "Disabled Hibernation"
}

Function Disable-IEFirstRun {
    # Disable Internet Explorer first run wizard
	
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Type DWord -Value 1
    Write-Output "Disabled Internet Explorer first run wizard."
}


If ($PSCommandPath -contains "psm1") { Export-ModuleMember -Function * }

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"