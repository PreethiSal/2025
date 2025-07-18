cd "C:\Program Files\Dell\CommandUpdate"
dcu-cli.exe /configure -proxyHost=proxyle03.ext.ti.com -proxyPort=80 -outputLog=C:\Temp\DCUProxy.log
dcu-cli.exe /applyupdates -silent -updateType=driver,bios -outputLog=C:\Temp\scanOutput.log