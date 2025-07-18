<#
    This will apply client baseline setting and capture all logs at C:\BaselineLogs
    Any modification to the code to be done on "TI.Client.Baseline.Settings.psm1"

    Prakash Prabhakar (prakashbp@ti.com)

#>

Function Start-Log ($PassPSCommandPath) {
    # Run this function to start transcript log
    
    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript -ErrorAction SilentlyContinue 2>&1 | out-null
    $timestamp = $(((get-date).ToUniversalTime()).ToString("yyyyMMddhhmmssff"))
    $LogRoot = "C:\BaselineLogs"  
	#$LogRoot = "C:\TIDeploy\Logs"
    If(!(test-path $LogRoot)) { New-Item -ItemType Directory -Force -Path $LogRoot } # create if not exists
    #If ($PassPSCommandPath -eq "") { $ScriptName = $MyInvocation.MyCommand.Name }
    $ScriptName = Split-Path $PassPSCommandPath -Leaf
    $global:TranscriptFile = "$LogRoot\$ScriptName.$timestamp.log"
    start-transcript -path $TranscriptFile 2>&1 | out-null
    write-host "$currenttime Started --- $PassPSCommandPath"
}

#=================== Main Code =============================

$ErrorActionPreference = "SilentlyContinue"
$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action { $global:currenttime= Get-Date }
Start-Log $PSCommandPath

# import PS module that all client baseline settings
Import-Module -DisableNameChecking -Global C:\Temp\TI.Client.Baseline.Settings.psm1

Disable-AutoSleep              #Disable all auto sleep to avoid entering sleep mode during the build

# tweaks related to user privacy
Disable-ContentDeliveryManager #This will update reg to disable appsuggestion, ootb bloatware like candy crus, and adverts for users)
Disable-ActivityHistory	       #To disable the Timeline, and stop sending users' activity history to Microsoft's servers.
Disable-AdvertisingID	       #This will disable Windows 10 creating unique advertising ID for each user  to learn and target ads
Disable-BackroundAccessApps	   #Disable Background application access - ie. apps can't download or update when they aren't used
Disable-ErrorReporting	       #Disable sending error reports to MS
Disable-Feedback	           #Disable Feedback prompts, and sending feedback to MS
Disable-FileExplorerAds	       #Disable MS pushing Ads in File Explorer
Disable-IEFirstRun	           #Disable IE First run Wizard
Disable-LocationTracking	   #Disable device location tracking built-in feature 
Disable-MapUpdates	           #Disable automatic Maps updates
Disable-PenWorkspaceAppSuggestions #Disable Windows Ink Workspace app suggestions Ads
Disable-SmartScreen		       #Disable SmartScreen Filter sending browsing/download data to MS
Disable-SpynetAutomaticSampleSubmission	#Disable spynet sending auto reports to MS
Disable-TailoredExperiences	   #Disable system sending diagnostic data to MS to provide personalized recommendations, tips and offers to tailor Windows for the user's needs,
Disable-Telemetry		       #Disable system sending technical data about the how the Windows devices and its related software is working and send this data periodically to MS
Disable-WiFiSense		       #Disable sharing your passkeys with your contacts to allow them to connect to your wireless network.

# OS tweaks for performace and security
Disable-AutoInstallNWDevices   #Disable automatic install of network devices
Disable-Autorun			       #Disable automatic start of programs from addon media
Enable-BalancedPowerScheme     #reset the Balanced power scheme to factory defaults and apply
Apply-MandatoryPowerSettings   #these are some of the power related setting from ITsec
Apply-ServicesSetting          #this will disable, set to auto / manual list of services
Disable-OOTBTasks              #This will disable out-of-the-box scheduled tasks that are not needed
Remove-OOTBApps                #This will remove out-of-the-box apps provisioned/installed that are not needed

Stamp-Baseline vBox            #This will update the registry with install method and baseline version

Write-host "$currenttime Ended --- $PSCommandPath"
Stop-Transcript -ErrorAction SilentlyContinue 2>&1 | out-null

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"