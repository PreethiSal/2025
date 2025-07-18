#Log path
$logpath = "C:\ProgramData\TILogs\ADMACWinicon"
$logname = "ADMACWinicon.log"   
If (Test-Path $logpath) {
    Start-Transcript -Path $logpath\$logname -force
    Write-Output $logpath" exists. Skipping creating new dir." 
}
Else {
    New-Item -Path $logpath -ItemType Directory | Out-Null
    Start-Transcript -Path $logpath\$logname -force
    Write-Output "The folder $logpath doesn't exist. Creating now." 
}
   
 #main script  
 $newPCname = $env:COMPUTERNAME
 write-host $newPCname
[String[]]$MAC = (netsh wlan show interfaces) -Match '^\s+Physical address' -Replace '^\s+Physical address\s+:\s+','' -replace ":","" | where-object { $_.trim() -ne "" } | sort-object -unique
write-host "Mac address"$MAC
$Result = $null
$url = "http://clientautomation.ent.ti.com:8443/Create-ADComp?Computername=$newPCname&MAC=$MAC"
$Result = curl $url
if ($result.content -match "Done") {
    Write-Host "Successfully joined domain and updated Wifi attributes in AD"
}
else {
    Write-Host "Error in domain join $($result.content)" 
}

Stop-Transcript