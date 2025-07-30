# === CONFIGURATION =====
# =======================
#$msuFolderPath = "c:\temp\Patches"  
# Checking msu file path  
# Get OS build number
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$buildNumber = [int]$osInfo.BuildNumber

# Determine folder based on build number
if ($buildNumber -ge 22000) {
    $msuFolderPath = "C:\Temp\Windows11"
} else {
    $msuFolderPath = "C:\Temp\Windows10"
}

Write-Host "Detected build $buildNumber. Using updates from: $msuFolderPath"   
$logPath = "C:\ProgramData\TILogs\MSU_Install_Log.txt"


# === FUNCTION: Write log entries ===
# ===================================
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp - $Message"
    Add-Content -Path $logPath -Value $entry
    Write-Host $entry
}

# === SETUP: Validate paths ===
if (-not (Test-Path $msuFolderPath)) {
    Write-Log "ERROR: Update folder '$msuFolderPath' does not exist."
    exit 1
}

if (-not (Test-Path (Split-Path $logPath))) {
    New-Item -ItemType Directory -Path (Split-Path $logPath) -Force | Out-Null
}

Write-Log "`n=== Starting MSU Installation via WUSA ==="

# === GET ALL .MSU FILES ===
$msuFiles = Get-ChildItem -Path $msuFolderPath -Filter *.msu -File

if ($msuFiles.Count -eq 0) {
    Write-Log "No .msu files found in: $msuFolderPath"
    exit 0
}

# === LOOP THROUGH FILES AND INSTALL ===
foreach ($msu in $msuFiles) {
    Write-Log "Processing: $($msu.Name)"

# extract KB number (for Get-HotFix check)
    if ($msu.Name -match "KB(\d{7})") {
        $kbID = "KB$($matches[1])"
    } else {
        $kbID = $null
    }

    # Check if update already installed
    if ($kbID -and (Get-HotFix | Where-Object { $_.HotFixID -eq $kbID })) {
        Write-Log "SKIPPED: $kbID already installed."
        continue
    }

    # Install using wusa.exe
    try {
        $arguments = "`"$($msu.FullName)`" /quiet /norestart"
        $process = Start-Process -FilePath "wusa.exe" -ArgumentList $arguments -Wait -PassThru

        switch ($process.ExitCode) {
            0             { Write-Log "SUCCESS: Installed $($msu.Name)" }
            3010          { Write-Log "SUCCESS: Installed $($msu.Name) - Restart Required" }
            2359302       { Write-Log "SKIPPED: $($msu.Name) - Already installed." }
            -2145124329   { Write-Log "SKIPPED: $($msu.Name) - Not applicable to this system." }
            default       { Write-Log "FAILED: $($msu.Name) with Exit Code: $($process.ExitCode)" }
        }
    } catch {
        Write-Log "ERROR: Exception installing $($msu.Name): $($_.Exception.Message)"
    }
}

Write-Log "=== MSU Installation process completed ==="