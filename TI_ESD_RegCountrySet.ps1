<#
.SYNOPSIS  
    This script will set the ESD server on the Windows client based on IP.

.DESCRIPTION
    This script depends on current IP and Subnet mask to find the site code and country. And, based on the country... ESD server is set. 
    
    Warning - This script has to be run as part of baseline install process, and should not be run outside of TI network or on VPN. 

.NOTES  
    Author        : Prakash Prabhakar (prakashbp@ti.com)
    Version       : 1.0.0.0 Initial Build 
    Creation Date : 18April2019
    Modified Date : 28July 2023
    Purpose       : To set ESD server on Windows client automatically as part of baseline install
    changes done  : The subnet .json file is loaded from a path which is update by the task scheduler.
                   HP and GF site codes were updated with new esd servers.
                   Added registry path for country and region(Preethi G salian)
    
#>

#######################################################
######  START LOCAL LOGS  ######
#######################################################
$logpath = "C:\ProgramData\TILogs\Set-ESDserver_MDT"
$logname = "Set-ESDserver_MDT.txt"   ## the logs are removed with the directory in cleanup actions, should it save somewhere else?
If (Test-Path $logpath) {
    Start-Transcript -Path $logpath\$logname -Append
    Write-Output $logpath" exists. Skipping creating new dir." 
}
Else {
    New-Item -Path $logpath -ItemType Directory | Out-Null
    Start-Transcript -Path $logpath\$logname -Append
    Write-Output "The folder $logpath doesn't exist. Creating now." 
}
$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action { $global:currenttime= Get-Date }

# Output the script name and version.
Write-host "$currenttime Started --- $PSCommandPath "

<#
Function Start-Log ($PassPSCommandPath) {
    # Run this function to start transcript log
    # Start-Log $PSCommandPath
    
    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript -ErrorAction SilentlyContinue 2>&1 | out-null
    #$timestamp = $(((get-date).ToUniversalTime()).ToString("yyyyMMddhhmmssff"))
    $timestamp = (Get-Date).ToString("yyyyMMddhhmmssff")
	$LogRoot = "C:\Windows\BaselineLogs"  
    If(!(test-path $LogRoot)) { New-Item -ItemType Directory -Force -Path $LogRoot } # create if not exists
    #If ($PassPSCommandPath -eq "") { $ScriptName = $MyInvocation.MyCommand.Name }
    $ScriptName = Split-Path $PassPSCommandPath -Leaf
    $global:TranscriptFile = "$LogRoot\$ScriptName.$timestamp.log"
    start-transcript -path $TranscriptFile 
    write-host $PassPSCommandPath
}   #>

Function Get-ESDserver ($TIsitecode) {
    # This will return timezone based on TI sitecode
    # The sitecode-country-region mapping is per  http://tiib/ti/lists/sitecode.json
    # (New-Object Net.WebClient).DownloadString(‘http://tiib/ti/lists/sitecode.json’) | ConvertFrom-Json | FT | Out-File .\site2region.csv 
   
     $output=@()
    $Site2ESDmap =@{


                   
                    'AN'='Xian', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'BJ'='Beijing_Des', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'CC'='Chengdu', 'China', 'Asia', 'DCCESD.itg.ti.com'
                    'CD'='Chengdu_Sales', 'China', 'Asia', 'DCCESD.itg.ti.com'
                    'CG'='Chongquing', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'CS'='Changsha', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'DO'='Dong_Guan', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'GZ'='Guangzhou', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'HA'='Hangzhou', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'HB'='Shanghai_Lab', 'China', 'Asia', 'dhuesd.itg.ti.com'
                    'HD'='Shanghai_PDC', 'China', 'Asia', 'dhuesd.itg.ti.com'
                    'HK'='HongKong', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'HP'='Shanghai_Des', 'China', 'Asia', 'dhpesd.itg.ti.com'
                    'HU'='Shanghai', 'China', 'Asia', 'dhuesd.itg.ti.com'
                    'HZ'='Shenzhen', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'J2'='JCAP_AT', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'JC'='Jiangsu', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'MI'='SMIC_Beijing', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'MS'='SMIC_Shanghai', 'China', 'Asia', 'dhuesd.itg.ti.com'
                    'NA'='Nanjing', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'QH'='HongKg(colo)', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'S5'='Sumida_Eltrc', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'SJ'='Suzhou', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'TD'='Qingdao', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'V5'='TATA-CEC', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'V7'='Verizon-MFG', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'WH'='Wuhan', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'XY'='Xiamen', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'ZA'='Asia_Surplus', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'ZI'='Zhuhai', 'China', 'Asia', 'dhkesd.itg.ti.com'
                    'BD'='Bangalore', 'India', 'Asia', 'dbdesd.itg.ti.com'
                    'CX'='Concentrix', 'India', 'Asia', 'dbdesd.itg.ti.com'
                    'ID'='New_Delhi', 'India', 'Asia', 'dbdesd.itg.ti.com'
                    'IE'='Pune', 'India', 'Asia', 'dbdesd.itg.ti.com'
                    'WP'='Wipro', 'India', 'Asia', 'dbdesd.itg.ti.com'
                    'A2'='ANAM', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'AK'='Kor-Ardentec', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'CK'='ChangWon', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'EK'='Sejong_Sales', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'KD'='Daegu_City', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'S9'='Suwon', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'SE'='Seoul', 'Korea', 'Asia', 'dseesd.itg.ti.com'
                    'KL'='Kuala_Lumpur', 'Malaysia', 'Asia', 'DKLESD.itg.ti.com'
                    'M8'='Penang', 'Malaysia', 'Asia', 'DKLESD.itg.ti.com'
                    'MK'='Malacca', 'Malaysia', 'Asia', 'dmkesd.itg.ti.com'
                    'BA'='Baguio', 'Philippines', 'Asia', 'dbaesd.itg.ti.com'
                    'CL'='Clark_AT', 'Philippines', 'Asia', 'DCLesd.itg.ti.com'
                    'P6'='Manila(BB)', 'Philippines', 'Asia', 'DCLesd.itg.ti.com'
                    'P7'='Rosephil(BB)', 'Philippines', 'Asia', 'DCLesd.itg.ti.com'
                    'GF'='Singapore_PDC', 'Singapore', 'Asia', 'dgfesd.itg.ti.com'
                    'GH'='Singapore_EXT', 'Singapore', 'Asia', 'dsiesd.itg.ti.com'
                    'QS'='Singap(colo)', 'Singapore', 'Asia', 'dsiesd.itg.ti.com'
                    'S0'='ST_Assm/Tst', 'Singapore', 'Asia', 'dsiesd.itg.ti.com'
                    'TJ'='SingTechJV', 'Singapore', 'Asia', 'dsiesd.itg.ti.com'
                    'UB'='Singapore_GDC', 'Singapore', 'Asia', 'dsiesd.itg.ti.com'
                    'UE'='SingaporeAPR', 'Singapore', 'Asia', 'dsiesd.itg.ti.com'
                    'A1'='Hsinchu_Sales', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'AR'='Ardentec(FAB)', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'I1'='IST(A/T)', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'KS'='Taiwan_Sales', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'LS'='Lingsen(A/T)', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'TA'='ChungHo', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'TE'='ChungHo_T2', 'Taiwan', 'Asia', 'dteesd.itg.ti.com'
                    'TH'='Taipei', 'Taiwan', 'Asia', 'dthesd.itg.ti.com'
                    'TK'='Amkor(DLP)', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'TP'='Taiwan_PDC', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'TQ'='TaichungSales', 'Taiwan', 'Asia', 'dtaesd.itg.ti.com'
                    'AI'='Millennium', 'Thailand', 'Asia', 'dhkesd.itg.ti.com'
                    'BX'='Alpha_Ventr', 'Thailand', 'Asia', 'dhkesd.itg.ti.com'
                    'S6'='Sumida', 'Thailand', 'Asia', 'dhkesd.itg.ti.com'
                    'TI'='Hana', 'Thailand', 'Asia', 'dhkesd.itg.ti.com'
                    'S3'='Austr-Xpedr', 'Australia', 'Australia', 'dhkesd.itg.ti.com'
                    'VN'='Vienna', 'Austria', 'Europe', 'deuesd.itg.ti.com'
                    'XM'='MMS_Sofia', 'Bulgaria', 'Europe', 'deuesd.itg.ti.com'
                    'PG'='Prague', 'Czechosl', 'Europe', 'deuesd.itg.ti.com'
                    'X0'='EEPIC_Prague', 'Czechosl', 'Europe', 'deuesd.itg.ti.com'
                    'EU'='London', 'England', 'Europe', 'deuesd.itg.ti.com'
                    'M6'='ManchesterGB', 'England', 'Europe', 'deuesd.itg.ti.com'
                    'NT'='Northampton', 'England', 'Europe', 'deuesd.itg.ti.com'
                    'V1'='Verizon-Corp', 'England', 'Europe', 'deuesd.itg.ti.com'
                    'V2'='TATA-Corp', 'England', 'Europe', 'deuesd.itg.ti.com'
                    'TL'='Tallinn', 'Estonia', 'Europe', 'deuesd.itg.ti.com'
                    'HE'='Helsinki', 'Finland', 'Europe', 'deuesd.itg.ti.com'
                    'OF'='Oulu(SVA)', 'Finland', 'Europe', 'deuesd.itg.ti.com'
                    'BB'='Boulogne', 'France', 'Europe', 'dncesd.itg.ti.com'
                    'LY'='Lyon', 'France', 'Europe', 'dncesd.itg.ti.com'
                    'EZ'='EMEA_Show', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'FR'='Freising', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'GA'='Garching', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'GB'='FilderstadtBB', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'GE'='Eschborn', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'H0'='Hannovr_Sales', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'MN'='Munich_Airpt', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'QF'='Frankft(colo)', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'RG'='Rattingen', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'ZE'='EMEA_Surplus', 'Germany', 'Europe', 'dfresd.itg.ti.com'
                    'BU'='Budapest', 'Hungary', 'Europe', 'deuesd.itg.ti.com'
                    'CO'='Cork', 'Ireland', 'Europe', 'deuesd.itg.ti.com'
                    'IS'='Raanana', 'Israel', 'Europe', 'dilesd.itg.ti.com'
                    'XJ'='Talpiot', 'Israel', 'Europe', 'dilesd.itg.ti.com'
                    'CI'='Catania', 'Italy', 'Europe', 'deuesd.itg.ti.com'
                    'IF'='Florence', 'Italy', 'Europe', 'deuesd.itg.ti.com'
                    'M2'='Milan(SVA)', 'Italy', 'Europe', 'deuesd.itg.ti.com'
                    'ML'='Milan', 'Italy', 'Europe', 'deuesd.itg.ti.com'
                    'EI'='Eindhoven', 'Netherlands', 'Europe', 'deuesd.itg.ti.com'
                    'U2'='Utrecht_PDC', 'Netherlands', 'Europe', 'deuesd.itg.ti.com'
                    'OS'='Oslo', 'Norway', 'Europe', 'deuesd.itg.ti.com'
                    'WA'='Warszawa', 'Poland', 'Europe', 'deuesd.itg.ti.com'
                    'XF'='NoBug-Bchr', 'Romania', 'Europe', 'deuesd.itg.ti.com'
                    'MR'='Moscow', 'Russia', 'Europe', 'deuesd.itg.ti.com'
                    'SP'='StPetersburg', 'Russia', 'Europe', 'deuesd.itg.ti.com'
                    'GR'='Greenock', 'Scotland', 'Europe', 'dgresd.itg.ti.com'
                    'XN'='Belgrade', 'Serbia', 'Europe', 'deuesd.itg.ti.com'
                    'MA'='Madrid', 'Spain', 'Europe', 'deuesd.itg.ti.com'
                    'GG'='Gothenburg', 'Sweden', 'Europe', 'deuesd.itg.ti.com'
                    'L7'='Lund', 'Sweden', 'Europe', 'deuesd.itg.ti.com'
                    'SM'='Stockholm', 'Sweden', 'Europe', 'deuesd.itg.ti.com'
                    'ZU'='Zurich', 'Switzerland', 'Europe', 'deuesd.itg.ti.com'
                    'TU'='Istanbul', 'Turkey', 'Europe', 'deuesd.itg.ti.com'
                    'AJ'='Aizu', 'Japan', 'Japan', 'dajesd.itg.ti.com'
                    'D1'='Densen-Kits', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'GO'='Nakaya', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'HH'='Kyuko-Hiji', 'Japan', 'Japan', 'dhiesd.itg.ti.com'
                    'HI'='Hiji', 'Japan', 'Japan', 'dhiesd.itg.ti.com'
                    'HJ'='Hiji-PAC', 'Japan', 'Japan', 'dhiesd.itg.ti.com'
                    'HT'='Kumamoto(SEC)', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'JF'='Fujiwara', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'JH'='Kyuko-Hiji', 'Japan', 'Japan', 'dhiesd.itg.ti.com'
                    'JR'='Renesas-HC', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'K2'='KitsukiTakaki', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'KK'='HijiSubcon', 'Japan', 'Japan', 'dhiesd.itg.ti.com'
                    'KT'='Kobe', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'KY'='Kyoto', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'M0'='Matsumoto', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'MH'='Miho', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'NN'='Nagoya', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'OA'='Osaka', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'QJ'='Tokyo(colo)', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'RH'='Rhythm', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'SI'='Saitama', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'T2'='Fujiwara2', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'TS'='Tokyo', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'TZ'='Takashima', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'V6'='KDDI-Japan', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'V8'='China-Telecom', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'V9'='Japan-PEther', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'YA'='TICT_Yatabe', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'YO'='Yokohama', 'Japan', 'Japan', 'djsesd.itg.ti.com'
                    'MQ'='Montreal', 'Canada', 'NorthAm', 'dleesd.itg.ti.com'
                    'OT'='Ottawa', 'Canada', 'NorthAm', 'dleesd.itg.ti.com'
                    'TM'='Mississauga', 'Canada', 'NorthAm', 'dleesd.itg.ti.com'
                    'TO'='Toronto_Des', 'Canada', 'NorthAm', 'dleesd.itg.ti.com'
                    'AO'='Aguas', 'Mexico', 'NorthAm', 'daoesd.itg.ti.com'
                    'GJ'='Guadalajara', 'Mexico', 'NorthAm', 'daoesd.itg.ti.com'
                    'MP'='Mexico_PDC', 'Mexico', 'NorthAm', 'daoesd.itg.ti.com'
                    'QW'='Aguas-QSMWH', 'Mexico', 'NorthAm', 'daoesd.itg.ti.com'
                    'WE'='Dextra-Aguas', 'Mexico', 'NorthAm', 'daoesd.itg.ti.com'
                    'B2'='Sao_Paulo', 'Brazil', 'SouthAm', 'daoesd.itg.ti.com'
                    'HV'='Huntsville', 'Alabama', 'USA', 'dleesd.itg.ti.com'
                    'AZ'='Tucson_HBA_2b', 'Arizona', 'USA', 'dleesd.itg.ti.com'
                    'CR'='Chandler', 'Arizona', 'USA', 'dleesd.itg.ti.com'
                    'TC'='Tucson_HPA', 'Arizona', 'USA', 'dleesd.itg.ti.com'
                    'C4'='SBarbra(Spec)', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'C5'='Grass_Valley', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'IV'='Irvine', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'LA'='Los_Angeles', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'NS'='Santa_Clara', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'SF'='San_Francisco', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'SG'='Sunnyvale', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'SO'='Sorrento-SD', 'California', 'USA', 'dnsesd.itg.ti.com'
                    'DS'='Broomfield', 'Colorado', 'USA', 'dleesd.itg.ti.com'
                    'FT'='Ft_Collins', 'Colorado', 'USA', 'dleesd.itg.ti.com'
                    'LC'='Longmont(SVA)', 'Colorado', 'USA', 'dleesd.itg.ti.com'
                    'DC'='WashingtonDC', 'DistrictC', 'USA', 'dleesd.itg.ti.com'
                    'BC'='Boca_Raton', 'Florida', 'USA', 'dleesd.itg.ti.com'
                    'AT'='Atlanta', 'Georgia', 'USA', 'dleesd.itg.ti.com'
                    'NG'='Norcross_Des', 'Georgia', 'USA', 'dleesd.itg.ti.com'
                    'PT'='Warrenville', 'Illinois', 'USA', 'dptesd.itg.ti.com'
                    'S8'='Schaumburg', 'Illinois', 'USA', 'dptesd.itg.ti.com'
                    'CE'='Carmel', 'Indiana', 'USA', 'dleesd.itg.ti.com'
                    'ME'='Portland', 'Maine', 'USA', 'dmeesd.itg.ti.com'
                    'GM'='Germantown', 'Maryland', 'USA', 'dgtesd.itg.ti.com'
                    'WM'='Waltham', 'Massachuss', 'USA', 'dleesd.itg.ti.com'
                    'SD'='Southfield', 'Michigan', 'USA', 'dleesd.itg.ti.com'
                    'BM'='Bloomington', 'Minnesota', 'USA', 'dleesd.itg.ti.com'
                    'S2'='St_Charles', 'Missouri', 'USA', 'dleesd.itg.ti.com'
                    'MY'='Manchester', 'NewHampshire', 'USA', 'dutesd.itg.ti.com'
                    'IN'='Iselin', 'NewJersey', 'USA', 'dleesd.itg.ti.com'
                    'PF'='Pittsfd_Sales', 'NewYork', 'USA', 'dleesd.itg.ti.com'
                    'CN'='Cary_Design', 'NorthCarol', 'USA', 'dleesd.itg.ti.com'
                    'BV'='Beaverton', 'Oregon', 'USA', 'dleesd.itg.ti.com'
                    'BE'='Bethlehem', 'Pennsylvania', 'USA', 'dleesd.itg.ti.com'
                    'RD'='Warwick', 'RhodeIsland', 'USA', 'dleesd.itg.ti.com'
                    'KN'='Knoxville', 'Tennessee', 'USA', 'dleesd.itg.ti.com'
                    'A6'='ATS-Dal', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'AA'='LvlI-Dal', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'AF'='Austin_Sales', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'AW'='Amazon_Web', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'BT'='Brit_Telcomm', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'CA'='Change(ADS)', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'CH'='Expy-Chemcal', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'CQ'='Expy-CUP', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'CU'='CreditUnion', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'D5'='DMOS5-DA', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'D6'='DMOS6-DA', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'D9'='RES_Lewallen', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'DA'='Dallas', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'DE'='Dallas_East', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'DF'='DFW', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'DK'='Expwy-DCON', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'DR'='DRP_Hotsite', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'DX'='DA-Scada', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'EE'='Alliance_FW', 'Texas', 'USA', 'deeesd.itg.ti.com'
                    'ES'='Expy-HazStg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'EX'='Exec_Mobile', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'EY'='Ernst_Young', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'FD'='Floyd_Rd', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'FE'='Expy-FleetMg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'FL'='Forest_Lane', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'FN'='Floyd_Rd_N', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'FO'='McKin-FlOps', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'G1'='Hyatt_Regncy', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'G4'='4G-LTE', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'HM'='Expy-Hazmat', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'HS'='Houston_Sales', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'HX'='High_Voltage', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'I2'='I2(Irving)', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'IP'='InterNap', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'KE'='Kilby_East', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'KW'='Kilby_West', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'LE'='Lewisville', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'MG'='Morgan_Semi', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'NB'='North_Bldg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'PH'='Padhu_Home', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'RE'='Research_East', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'RF'='RichardsnFAB', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'RT'='RFAB_Admin', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'SB'='South_Bldg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'SC'='SC_Bldg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'SH'='Sherman', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'SL'='Sugarland', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'SS'='Expy-Securty', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'T1'='Expy-TimeBlg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'TR'='Tower_Bldg', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'TX'='Expy-Texins', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'UA'='Austin-Unitrd', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'V0'='ATT-Corp', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'VG'='Vanguard_Ren', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'WC'='WWCC', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'XK'='Nokia(Irving)', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'ZW'='ECOMM_Spares', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'ZX'='USA_Surplus', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'ZZ'='Remote_Stock', 'Texas', 'USA', 'dleesd.itg.ti.com'
                    'S4'='Redmond', 'Washington', 'USA', 'dleesd.itg.ti.com'
                    'WT'='Federal_Way', 'Washington', 'USA', 'dleesd.itg.ti.com'
                    'BO'='Brookfield', 'Wisconsin', 'USA', 'dleesd.itg.ti.com'
                    'LF'='Lehi', 'Utah', 'USA', 'lfwesd.itg.ti.com'

    }

    If ( $Site2ESDmap.ContainsKey($TIsitecode) ){ 
   
    
   #{ return (($Site2ESDmap.($TIsitecode))[3]),(($Site2ESDmap.($TIsitecode))[1]),(($Site2ESDmap.($TIsitecode))[2])}
    
            $output+=[pscustomobject]@{
            ESDServer=($Site2ESDmap.($TIsitecode))[3]
            Country=($Site2ESDmap.($TIsitecode))[1]
            Region=($Site2ESDmap.($TIsitecode))[2]
			Sitename=($Site2ESDmap.($TIsitecode))[0]
			Site=$TIsitecode
                 }
                 }
                 return $output  
}


function ConvertTo-IPv4MaskString {
    # This will convert IPv4 subnet maskbits to address/string
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 32)]
        [Int] $MaskBits
    )
    $mask = ([Math]::Pow(2, $MaskBits) - 1) * [Math]::Pow(2, (32 - $MaskBits))
    $bytes = [BitConverter]::GetBytes([UInt32] $mask)
    (($bytes.Count - 1)..0 | ForEach-Object { [String] $bytes[$_] }) -join "."
}

function Test-IPv4MaskString {
    # This will check if IPv4 subnet address/string is valid
    param(
        [Parameter(Mandatory = $true)]
        [String] $MaskString
    )
    $validBytes = '0|128|192|224|240|248|252|254|255'
    $MaskString -match `
    ('^((({0})\.0\.0\.0)|'      -f $validBytes) +
    ('(255\.({0})\.0\.0)|'      -f $validBytes) +
    ('(255\.255\.({0})\.0)|'    -f $validBytes) +
    ('(255\.255\.255\.({0})))$' -f $validBytes)
}

function ConvertTo-IPv4MaskBits {
    # This will convert IPv4 subnet address/string to maskbits
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript({Test-IPv4MaskString $_})]
        [String] $MaskString
    )
    $mask = ([IPAddress] $MaskString).Address
    for ( $bitCount = 0; $mask -ne 0; $bitCount++ ) {
        $mask = $mask -band ($mask - 1)
    }
    $bitCount
}


# Select the NIC that is loaded with TI DHCP IP
$nic = gwmi -computer . -class "win32_networkadapterconfiguration" | Where-Object {($_.defaultIPGateway -ne $null) -and ($_.defaultIPGateway -ne "192.168.1.1" ) -and ($_.DNSDomain -eq "dhcp.ti.com" ) }
$IP = $nic.ipaddress | select-object -first 1
$ClientMask = $nic.ipsubnet | select-object -first 1

# This can convert maskaddress to maskbits but currently using the function... if needed this could also be used
#(($ClientMask -split '\.' | % { [convert]::ToString($_,2) } ) -join '').tochararray() | % { $subnet += ([convert]::ToInt32($_)-48) }
#$IP + '/' + $subnet

# get the network address
$netAdd = [IPAddress] ( (([IPAddress] $IP).Address) -band ([IPAddress] (ConvertTo-IPv4MaskString (ConvertTo-IPv4MaskBits $ClientMask) )).Address)

# get network to sitecode
#$NetworkToSitecode = (New-Object Net.WebClient).DownloadString(‘http://tiib.itg.ti.com/reports/networks.json’) | ConvertFrom-Json   
#$NetworkToSitecode = (New-Object Net.WebClient).DownloadString(‘http://getwindows.itg.ti.com/data/networks.json’) | ConvertFrom-Json 
$NetworkToSitecode = Get-content -raw -path C:\temp\subnets_dump.json | ConvertFrom-Json 
#$Testjson.Networks | FT 
Foreach ($netwrok in $NetworkToSitecode) { 
    If ( $netwrok.address -eq $netAdd) {
        #Write-Host $netwrok.sitecode, $netwrok.comment, $netwrok.regions
        $pcsitecode=$netwrok.sitecode
        #write-host $pcsitecode
    }
}

#get ESD server
$ESD = Get-ESDserver $pcsitecode

If ($ESDserver -ne "") {

    #set ESD server
    Try {
        If (!(Test-Path "HKLM:\Software\TI")) {
	        New-Item -Path "HKLM:\Software\TI" -Force | Out-Null
        }
        if(!(Test-Path "HKLM:\Software\TI\Baseline")) {
	        New-Item -Path "HKLM:\Software\TI\Baseline" -Force | Out-Null
        }
        Set-ItemProperty -Path HKLM:\Software\TI -Name Server -Type String -Value $ESD.ESDserver -ErrorAction stop
	    Set-ItemProperty -Path HKLM:\Software\TI\Baseline -Name Country -Type String -Value $ESD.Country -ErrorAction stop
	    Set-ItemProperty -Path HKLM:\Software\TI\Baseline -Name Region -Type String -Value $ESD.Region -ErrorAction stop
     	Set-ItemProperty -Path HKLM:\Software\TI\Baseline -Name Site -Type String -Value $ESD.Site -ErrorAction stop
		Set-ItemProperty -Path HKLM:\Software\TI\Baseline -Name Sitename -Type String -Value $ESD.Sitename -ErrorAction stop
		
        Write-Host $ESD.ESDserver "is the ESD server" 
		Write-Host $ESD.country "is the ESD Country"
		Write-Host $ESD.region "is the ESD Region"
		Write-Host $ESD.site "is the ESD Site"
        
    } Catch { Write-Warning "$($_.Exception.Message)" }
} Else { Write-Host "Cannot find the ESD server... please check if TIIB.itg.ti.com is reachable" } 

Write-Host "$currenttime End of script"      

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