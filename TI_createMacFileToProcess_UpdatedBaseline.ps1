$logpath = "C:\ProgramData\TILogs\TI_SetADattributes.log"
function writelog
{
    Param([String]$msg)
    #$time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+"`n===============================")#+$time)
}

$ComputerName = hostname
$tiPerHostMac = ((Get-NetAdapter -Name "Wi-Fi").MacAddress).replace("-","")
$attributeVal="1"

$ComputerInfo = Get-ADComputer -Identity $ComputerName -Properties *
writelog "Computer Details are:`nHostname: $ComputerName`nMAC Address: $(($ComputerInfo).tiPerHostMac)`ntiPerDeviceType: $(($ComputerInfo).tiPerDeviceType)`ntiPerWLNetAZ: $(($ComputerInfo).tiPerWLNetAZ)`ntiPerWRNetAZ: $(($ComputerInfo).tiPerWRNetAZ)"

Set-ADComputer -Identity $($ComputerInfo).SamAccountName –replace @{tiPerDeviceType=$attributeVal;tiPerWLNetAZ=$attributeVal;tiPerWRNetAZ=$attributeVal;tiPerHostMac=@($tiPerHostMac)}

writelog "Computer details have been updated as:`nHostname: $ComputerName`nMAC Address: $tiPerHostMac`ntiPerDeviceType: $attributeVal`ntiPerWLNetAZ: $attributeVal`ntiPerWRNetAZ: $attributeVal"