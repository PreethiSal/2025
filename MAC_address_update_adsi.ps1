$logFilePath = "C:\ProgramData\TIlogs"
$logFileName = "testLogFile.txt"
#$directoryPath = "\\lewvclientdev.ent.ti.com\mdtmartin$\Scripts\attributeProject.ps1"

If (Test-Path $logFilePath) 
{
    Start-Transcript -Path $logFilePath\$logFileName -Append
    Write-Host
    Write-Host "The directory $logFilePath exists. Skipping creating new directory."
}

Else
{
    New-Item -Path $logFilePath -ItemType Directory | Out-Null
    Start-Transcript -Path $logFilePath\$logFileName -Append
    Write-Host "The directory $logFilePath did not exist. Creating new directory."
}



#Logging!

#Verifying log file directory existence, creating directory if nonexistent.

$logFilePath = "C:\ProgramData\TIlogs"
$logFileName = "attributeLogFile.txt"

If (Test-Path $logFilePath) 
{
    Start-Transcript -Path $logFilePath\$logFileName -Append
    Write-Host
    Write-Host "The directory $logFilePath exists. Skipping creating new directory."
}

Else
{
    New-Item -Path $logFilePath -ItemType Directory | Out-Null
    Start-Transcript -Path $logFilePath\$logFileName -Append
    Write-Host "The directory $logFilePath did not exist. Creating new directory."
}

#Grabbing Computer Information!

#Get the computer name and store it in a variable.

Write-Host "Grabbing computer name..."
$computerName = $env:COMPUTERNAME

Write-Host "Grabbing mac address..."
#$getMacAddress =  (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {($_.Description -like "*Wi-Fi*" -or $_.Description -like "*wireless*") -and $_.description -notlike "*Virtual*"}).macaddress -replace ":","" 
$getMacAddress = (netsh wlan show interfaces) -Match '^\s+Physical address' -Replace '^\s+Physical address\s+:\s+','' -replace ":","" 
write-host "Mac address is :"$getMacAddress
#Mac Address Check!

#If there is a computer with a Mac Address already in use, notify the user running the task sequence through outlook.
$entRoot = New-Object System.DirectoryServices.DirectoryEntry('LDAP://ent.ti.com')

 $attributeSearcher = New-Object System.DirectoryServices.DirectorySearcher($entRoot,"(&(objectCategory=computer)(tiPerHostMac=$getMacAddress))")

$findMacAddressComputers = $attributeSearcher.FindAll()
write-host "MacAddressComputers in AD":$getMacAddress
if($findMacAddressComputers.Count.Equals(0))
{
    Write-Host "No user with this mac address was found..."
    Write-Host "Proceeding to update mac address attribute tiPerHostMac..."

    #Update computer object attribute tiPerHostMac (Mac Address).

    Write-Host "Retrieving computer object using adsi..."

    $entRoot = New-Object System.DirectoryServices.DirectoryEntry('LDAP://ent.ti.com')



    $searcher= New-Object System.DirectoryServices.DirectorySearcher($entRoot,"(&(objectCategory=computer)(sAMAccountname=$($computerName)$))")

    $computerDN = $searcher.FindOne()


    Write-Host "Updating attribute in active directory..."

    try {
            $user = [adsi]($computerDN.Properties.adspath[0])
            $user.Put("tiPerHostMac",$getMacAddress)
            $user.Put("tiPerDeviceType",1)
            $user.Put("tiPerWLNetAZ",1)
            $user.Put("tiPerWRNetAZ",1)
            $user.SetInfo()
            Write-Host "Success.."
        } catch {Write-Host "Failed ADSI attribute update..."}

    Write-Host "Updated attribute value:" $user.Properties.tiPerHostMac


}
else
{
    Write-Host "Failure..."
    Write-Host "Computer(s) with this Mac Address already exists..."
    Write-Host "Computer count:" $findMacAddressComputers.Count
    Write-Host "sAMAccountName(s):" ($findMacAddressComputers.GetDirectoryEntry() | ForEach-Object{ $_.sAMAccountName })
    
}

Stop-Transcript
