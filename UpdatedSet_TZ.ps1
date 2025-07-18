#Modifying the script freshly and keeping it clean with one logging  
<#
.SYNOPSIS  
    This script will set the time zone on the Windows client based on IP.

.DESCRIPTION
    This script depends on current IP and Subnet mask to find the site code and country. And, based on the country... timezone is set. 
    Reference - https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones

    Warning - This script has to be run as part of baseline install process, and should not be run outside of TI network or on VPN. The timezone may be set incorrectly if it is run on VPN.

.NOTES  
    Author        : Prakash Prabhakar (prakashbp@ti.com)
    Version       : 1.0.0.0 Initial Build 
    Creation Date : 12April2019
    Purpose       : To set Windows client timezone automatically as part of baseline install
    
#>
#######################################################
######  START LOCAL LOGS  ######
#######################################################
$logpath = "C:\ProgramData\TILogs\"
$logname = "Set-TimeZone.txt"   ## the logs are removed with the directory in cleanup actions, should it save somewhere else?
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


Function Get-TimeZone($TIsitecode) {
    try{
    $Site2TZmap =@{
                'AN'='Xian', 'China', 'Asia', 'China Standard Time'
                'BJ'='Beijing_Des', 'China', 'Asia', 'China Standard Time'
                'CC'='Chengdu', 'China', 'Asia', 'China Standard Time'
                'CD'='Chengdu_Sales', 'China', 'Asia', 'China Standard Time'
                'CG'='Chongquing', 'China', 'Asia', 'China Standard Time'
                'CS'='Changsha', 'China', 'Asia', 'China Standard Time'
                'DO'='Dong_Guan', 'China', 'Asia', 'China Standard Time'
                'GZ'='Guangzhou', 'China', 'Asia', 'China Standard Time'
                'HA'='Hangzhou', 'China', 'Asia', 'China Standard Time'
                'HB'='Shanghai_Lab', 'China', 'Asia', 'China Standard Time'
                'HD'='Shanghai_PDC', 'China', 'Asia', 'China Standard Time'
                'HK'='HongKong', 'China', 'Asia', 'China Standard Time'
                'HP'='Shanghai_Des', 'China', 'Asia', 'China Standard Time'
                'HU'='Shanghai', 'China', 'Asia', 'China Standard Time'
                'HZ'='Shenzhen', 'China', 'Asia', 'China Standard Time'
                'J2'='JCAP_AT', 'China', 'Asia', 'China Standard Time'
                'JC'='Jiangsu', 'China', 'Asia', 'China Standard Time'
                'MI'='SMIC_Beijing', 'China', 'Asia', 'China Standard Time'
                'MS'='SMIC_Shanghai', 'China', 'Asia', 'China Standard Time'
                'NA'='Nanjing', 'China', 'Asia', 'China Standard Time'
                'QH'='HongKg(colo)', 'China', 'Asia', 'China Standard Time'
                'S5'='Sumida_Eltrc', 'China', 'Asia', 'China Standard Time'
                'SJ'='Suzhou', 'China', 'Asia', 'China Standard Time'
                'TD'='Qingdao', 'China', 'Asia', 'China Standard Time'
                'V5'='TATA-CEC', 'China', 'Asia', 'China Standard Time'
                'V7'='Verizon-MFG', 'China', 'Asia', 'China Standard Time'
                'WH'='Wuhan', 'China', 'Asia', 'China Standard Time'
                'XY'='Xiamen', 'China', 'Asia', 'China Standard Time'
                'ZA'='Asia_Surplus', 'China', 'Asia', 'China Standard Time'
                'ZI'='Zhuhai', 'China', 'Asia', 'China Standard Time'
                'BD'='Bangalore', 'India', 'Asia', 'India Standard Time'
                'CX'='Concentrix', 'India', 'Asia', 'India Standard Time'
                'ID'='New_Delhi', 'India', 'Asia', 'India Standard Time'
                'IE'='Pune', 'India', 'Asia', 'India Standard Time'
                'WP'='Wipro', 'India', 'Asia', 'India Standard Time'
                'A2'='ANAM', 'Korea', 'Asia', 'Korea Standard Time'
                'AK'='Kor-Ardentec', 'Korea', 'Asia', 'Korea Standard Time'
                'CK'='ChangWon', 'Korea', 'Asia', 'Korea Standard Time'
                'EK'='Sejong_Sales', 'Korea', 'Asia', 'Korea Standard Time'
                'KD'='Daegu_City', 'Korea', 'Asia', 'Korea Standard Time'
                'S9'='Suwon', 'Korea', 'Asia', 'Korea Standard Time'
                'SE'='Seoul', 'Korea', 'Asia', 'Korea Standard Time'
                'KL'='Kuala_Lumpur', 'Malaysia', 'Asia', 'Singapore Standard Time'
                'M8'='Penang', 'Malaysia', 'Asia', 'Singapore Standard Time'
                'MK'='Malacca', 'Malaysia', 'Asia', 'Singapore Standard Time'
                'BA'='Baguio', 'Philippines', 'Asia', 'Singapore Standard Time'
                'CL'='Clark_AT', 'Philippines', 'Asia', 'Singapore Standard Time'
                'P6'='Manila(BB)', 'Philippines', 'Asia', 'Singapore Standard Time'
                'P7'='Rosephil(BB)', 'Philippines', 'Asia', 'Singapore Standard Time'
                'GF'='Singapore_PDC', 'Singapore', 'Asia', 'Singapore Standard Time'
                'GH'='Singapore_EXT', 'Singapore', 'Asia', 'Singapore Standard Time'
                'QS'='Singap(colo)', 'Singapore', 'Asia', 'Singapore Standard Time'
                'S0'='ST_Assm/Tst', 'Singapore', 'Asia', 'Singapore Standard Time'
                'TJ'='SingTechJV', 'Singapore', 'Asia', 'Singapore Standard Time'
                'UB'='Singapore_GDC', 'Singapore', 'Asia', 'Singapore Standard Time'
                'UE'='SingaporeAPR', 'Singapore', 'Asia', 'Singapore Standard Time'
                'A1'='Hsinchu_Sales', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'AR'='Ardentec(FAB)', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'I1'='IST(A/T)', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'KS'='Taiwan_Sales', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'LS'='Lingsen(A/T)', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'TA'='ChungHo', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'TE'='ChungHo_T2', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'TH'='Taipei', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'TK'='Amkor(DLP)', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'TP'='Taiwan_PDC', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'TQ'='TaichungSales', 'Taiwan', 'Asia', 'Taipei Standard Time'
                'AI'='Millennium', 'Thailand', 'Asia', 'SE Asia Standard Time'
                'BX'='Alpha_Ventr', 'Thailand', 'Asia', 'SE Asia Standard Time'
                'S6'='Sumida', 'Thailand', 'Asia', 'SE Asia Standard Time'
                'TI'='Hana', 'Thailand', 'Asia', 'SE Asia Standard Time'
                'S3'='Austr-Xpedr', 'Australia', 'Australia', 'AUS Eastern Standard Time'
                'VN'='Vienna', 'Austria', 'Europe', 'W. Europe Standard Time'
                'XM'='MMS_Sofia', 'Bulgaria', 'Europe', 'FLE Standard Time'
                'PG'='Prague', 'Czechosl', 'Europe', 'Central Europe Standard Time'
                'X0'='EEPIC_Prague', 'Czechosl', 'Europe', 'Central Europe Standard Time'
                'EU'='London', 'England', 'Europe', 'GMT Standard Time'
                'M6'='ManchesterGB', 'England', 'Europe', 'GMT Standard Time'
                'NT'='Northampton', 'England', 'Europe', 'GMT Standard Time'
                'V1'='Verizon-Corp', 'England', 'Europe', 'GMT Standard Time'
                'V2'='TATA-Corp', 'England', 'Europe', 'GMT Standard Time'
                'TL'='Tallinn', 'Estonia', 'Europe', 'FLE Standard Time'
                'HE'='Helsinki', 'Finland', 'Europe', 'FLE Standard Time'
                'OF'='Oulu(SVA)', 'Finland', 'Europe', 'FLE Standard Time'
                'BB'='Boulogne', 'France', 'Europe', 'Romance Standard Time'
                'LY'='Lyon', 'France', 'Europe', 'Romance Standard Time'
                'EZ'='EMEA_Show', 'Germany', 'Europe', 'W. Europe Standard Time'
                'FR'='Freising', 'Germany', 'Europe', 'W. Europe Standard Time'
                'GA'='Garching', 'Germany', 'Europe', 'W. Europe Standard Time'
                'GB'='FilderstadtBB', 'Germany', 'Europe', 'W. Europe Standard Time'
                'GE'='Eschborn', 'Germany', 'Europe', 'W. Europe Standard Time'
                'H0'='Hannovr_Sales', 'Germany', 'Europe', 'W. Europe Standard Time'
                'MN'='Munich_Airpt', 'Germany', 'Europe', 'W. Europe Standard Time'
                'QF'='Frankft(colo)', 'Germany', 'Europe', 'W. Europe Standard Time'
                'RG'='Rattingen', 'Germany', 'Europe', 'W. Europe Standard Time'
                'ZE'='EMEA_Surplus', 'Germany', 'Europe', 'W. Europe Standard Time'
                'BU'='Budapest', 'Hungary', 'Europe', 'Central Europe Standard Time'
                'CO'='Cork', 'Ireland', 'Europe', 'GMT Standard Time'
                'IS'='Raanana', 'Israel', 'Europe', 'Israel Standard Time'
                'XJ'='Talpiot', 'Israel', 'Europe', 'Israel Standard Time'
                'CI'='Catania', 'Italy', 'Europe', 'W. Europe Standard Time'
                'IF'='Florence', 'Italy', 'Europe', 'W. Europe Standard Time'
                'M2'='Milan(SVA)', 'Italy', 'Europe', 'W. Europe Standard Time'
                'ML'='Milan', 'Italy', 'Europe', 'W. Europe Standard Time'
                'EI'='Eindhoven', 'Netherlands', 'Europe', 'W. Europe Standard Time'
                'U2'='Utrecht_PDC', 'Netherlands', 'Europe', 'W. Europe Standard Time'
                'OS'='Oslo', 'Norway', 'Europe', 'W. Europe Standard Time'
                'WA'='Warszawa', 'Poland', 'Europe', 'Central European Standard Time'
                'XF'='NoBug-Bchr', 'Romania', 'Europe', 'GTB Standard Time'
                'MR'='Moscow', 'Russia', 'Europe', 'Russian Standard Time'
                'SP'='StPetersburg', 'Russia', 'Europe', 'Russian Standard Time'
                'GR'='Greenock', 'Scotland', 'Europe', 'GMT Standard Time'
                'XN'='Belgrade', 'Serbia', 'Europe', 'Central Europe Standard Time'
                'MA'='Madrid', 'Spain', 'Europe', 'Romance Standard Time'
                'GG'='Gothenburg', 'Sweden', 'Europe', 'W. Europe Standard Time'
                'L7'='Lund', 'Sweden', 'Europe', 'W. Europe Standard Time'
                'SM'='Stockholm', 'Sweden', 'Europe', 'W. Europe Standard Time'
                'ZU'='Zurich', 'Switzerland', 'Europe', 'W. Europe Standard Time'
                'TU'='Istanbul', 'Turkey', 'Europe', 'Turkey Standard Time'
                'AJ'='Aizu', 'Japan', 'Japan', 'Tokyo Standard Time'
                'D1'='Densen-Kits', 'Japan', 'Japan', 'Tokyo Standard Time'
                'GO'='Nakaya', 'Japan', 'Japan', 'Tokyo Standard Time'
                'HH'='Kyuko-Hiji', 'Japan', 'Japan', 'Tokyo Standard Time'
                'HI'='Hiji', 'Japan', 'Japan', 'Tokyo Standard Time'
                'HJ'='Hiji-PAC', 'Japan', 'Japan', 'Tokyo Standard Time'
                'HT'='Kumamoto(SEC)', 'Japan', 'Japan', 'Tokyo Standard Time'
                'JF'='Fujiwara', 'Japan', 'Japan', 'Tokyo Standard Time'
                'JH'='Kyuko-Hiji', 'Japan', 'Japan', 'Tokyo Standard Time'
                'JR'='Renesas-HC', 'Japan', 'Japan', 'Tokyo Standard Time'
                'K2'='KitsukiTakaki', 'Japan', 'Japan', 'Tokyo Standard Time'
                'KK'='HijiSubcon', 'Japan', 'Japan', 'Tokyo Standard Time'
                'KT'='Kobe', 'Japan', 'Japan', 'Tokyo Standard Time'
                'KY'='Kyoto', 'Japan', 'Japan', 'Tokyo Standard Time'
                'M0'='Matsumoto', 'Japan', 'Japan', 'Tokyo Standard Time'
                'MH'='Miho', 'Japan', 'Japan', 'Tokyo Standard Time'
                'NN'='Nagoya', 'Japan', 'Japan', 'Tokyo Standard Time'
                'OA'='Osaka', 'Japan', 'Japan', 'Tokyo Standard Time'
                'QJ'='Tokyo(colo)', 'Japan', 'Japan', 'Tokyo Standard Time'
                'RH'='Rhythm', 'Japan', 'Japan', 'Tokyo Standard Time'
                'SI'='Saitama', 'Japan', 'Japan', 'Tokyo Standard Time'
                'T2'='Fujiwara2', 'Japan', 'Japan', 'Tokyo Standard Time'
                'TS'='Tokyo', 'Japan', 'Japan', 'Tokyo Standard Time'
                'TZ'='Takashima', 'Japan', 'Japan', 'Tokyo Standard Time'
                'V6'='KDDI-Japan', 'Japan', 'Japan', 'Tokyo Standard Time'
                'V8'='China-Telecom', 'Japan', 'Japan', 'Tokyo Standard Time'
                'V9'='Japan-PEther', 'Japan', 'Japan', 'Tokyo Standard Time'
                'YA'='TICT_Yatabe', 'Japan', 'Japan', 'Tokyo Standard Time'
                'YO'='Yokohama', 'Japan', 'Japan', 'Tokyo Standard Time'
                'MQ'='Montreal', 'Canada', 'NorthAm', 'Eastern Standard Time'
                'OT'='Ottawa', 'Canada', 'NorthAm', 'Eastern Standard Time'
                'TM'='Mississauga', 'Canada', 'NorthAm', 'Eastern Standard Time'
                'TO'='Toronto_Des', 'Canada', 'NorthAm', 'Eastern Standard Time'
                'AO'='Aguas', 'Mexico', 'NorthAm', 'Central Standard Time'
                'GJ'='Guadalajara', 'Mexico', 'NorthAm', 'Central Standard Time'
                'MP'='Mexico_PDC', 'Mexico', 'NorthAm', 'Central Standard Time'
                'QW'='Aguas-QSMWH', 'Mexico', 'NorthAm', 'Central Standard Time'
                'WE'='Dextra-Aguas', 'Mexico', 'NorthAm', 'Central Standard Time'
                'B2'='Sao_Paulo', 'Brazil', 'SouthAm', 'Central Standard Time'
                'HV'='Huntsville', 'Alabama', 'USA', 'Central Standard Time'
                'AZ'='Tucson_HBA_2b', 'Arizona', 'USA', 'Mountain Standard Time'
                'CR'='Chandler', 'Arizona', 'USA', 'Mountain Standard Time'
                'TC'='Tucson_HPA', 'Arizona', 'USA', 'Mountain Standard Time'
                'C4'='SBarbra(Spec)', 'California', 'USA', 'Pacific Standard Time'
                'C5'='Grass_Valley', 'California', 'USA', 'Pacific Standard Time'
                'IV'='Irvine', 'California', 'USA', 'Pacific Standard Time'
                'LA'='Los_Angeles', 'California', 'USA', 'Pacific Standard Time'
                'NS'='Santa_Clara', 'California', 'USA', 'Pacific Standard Time'
                'SF'='San_Francisco', 'California', 'USA', 'Pacific Standard Time'
                'SG'='Sunnyvale', 'California', 'USA', 'Pacific Standard Time'
                'SO'='Sorrento-SD', 'California', 'USA', 'Pacific Standard Time'
                'DS'='Broomfield', 'Colorado', 'USA', 'Mountain Standard Time'
                'FT'='Ft_Collins', 'Colorado', 'USA', 'Mountain Standard Time'
                'LC'='Longmont(SVA)', 'Colorado', 'USA', 'Mountain Standard Time'
                'DC'='WashingtonDC', 'DistrictC', 'USA', 'Eastern Standard Time'
                'BC'='Boca_Raton', 'Florida', 'USA', 'Eastern Standard Time'
                'AT'='Atlanta', 'Georgia', 'USA', 'Eastern Standard Time'
                'NG'='Norcross_Des', 'Georgia', 'USA', 'Eastern Standard Time'
                'PT'='Warrenville', 'Illinois', 'USA', 'Central Standard Time'
                'S8'='Schaumburg', 'Illinois', 'USA', 'Central Standard Time'
                'CE'='Carmel', 'Indiana', 'USA', 'Eastern Standard Time'
                'ME'='Portland', 'Maine', 'USA', 'Eastern Standard Time'
                'GM'='Germantown', 'Maryland', 'USA', 'Eastern Standard Time'
                'WM'='Waltham', 'Massachuss', 'USA', 'Eastern Standard Time'
                'SD'='Southfield', 'Michigan', 'USA', 'Eastern Standard Time'
                'BM'='Bloomington', 'Minnesota', 'USA', 'Central Standard Time'
                'S2'='St_Charles', 'Missouri', 'USA', 'Central Standard Time'
                'MY'='Manchester', 'NewHampshire', 'USA', 'Eastern Standard Time'
                'IN'='Iselin', 'NewJersey', 'USA', 'Eastern Standard Time'
                'PF'='Pittsfd_Sales', 'NewYork', 'USA', 'Eastern Standard Time'
                'CN'='Cary_Design', 'NorthCarol', 'USA', 'Eastern Standard Time'
                'BV'='Beaverton', 'Oregon', 'USA', 'Pacific Standard Time'
                'BE'='Bethlehem', 'Pennsylvania', 'USA', 'Eastern Standard Time'
                'RD'='Warwick', 'RhodeIsland', 'USA', 'Eastern Standard Time'
                'KN'='Knoxville', 'Tennessee', 'USA', 'Central Standard Time'
                'A6'='ATS-Dal', 'Texas', 'USA', 'Central Standard Time'
                'AA'='LvlI-Dal', 'Texas', 'USA', 'Central Standard Time'
                'AF'='Austin_Sales', 'Texas', 'USA', 'Central Standard Time'
                'AW'='Amazon_Web', 'Texas', 'USA', 'Central Standard Time'
                'BT'='Brit_Telcomm', 'Texas', 'USA', 'Central Standard Time'
                'CA'='Change(ADS)', 'Texas', 'USA', 'Central Standard Time'
                'CH'='Expy-Chemcal', 'Texas', 'USA', 'Central Standard Time'
                'CQ'='Expy-CUP', 'Texas', 'USA', 'Central Standard Time'
                'CU'='CreditUnion', 'Texas', 'USA', 'Central Standard Time'
                'D5'='DMOS5-DA', 'Texas', 'USA', 'Central Standard Time'
                'D6'='DMOS6-DA', 'Texas', 'USA', 'Central Standard Time'
                'D9'='RES_Lewallen', 'Texas', 'USA', 'Central Standard Time'
                'DA'='Dallas', 'Texas', 'USA', 'Central Standard Time'
                'DE'='Dallas_East', 'Texas', 'USA', 'Central Standard Time'
                'DF'='DFW', 'Texas', 'USA', 'Central Standard Time'
                'DK'='Expwy-DCON', 'Texas', 'USA', 'Central Standard Time'
                'DR'='DRP_Hotsite', 'Texas', 'USA', 'Central Standard Time'
                'DX'='DA-Scada', 'Texas', 'USA', 'Central Standard Time'
                'EE'='Alliance_FW', 'Texas', 'USA', 'Central Standard Time'
                'ES'='Expy-HazStg', 'Texas', 'USA', 'Central Standard Time'
                'EX'='Exec_Mobile', 'Texas', 'USA', 'Central Standard Time'
                'EY'='Ernst_Young', 'Texas', 'USA', 'Central Standard Time'
                'FD'='Floyd_Rd', 'Texas', 'USA', 'Central Standard Time'
                'FE'='Expy-FleetMg', 'Texas', 'USA', 'Central Standard Time'
                'FL'='Forest_Lane', 'Texas', 'USA', 'Central Standard Time'
                'FN'='Floyd_Rd_N', 'Texas', 'USA', 'Central Standard Time'
                'FO'='McKin-FlOps', 'Texas', 'USA', 'Central Standard Time'
                'G1'='Hyatt_Regncy', 'Texas', 'USA', 'Central Standard Time'
                'G4'='4G-LTE', 'Texas', 'USA', 'Central Standard Time'
                'HM'='Expy-Hazmat', 'Texas', 'USA', 'Central Standard Time'
                'HS'='Houston_Sales', 'Texas', 'USA', 'Central Standard Time'
                'HX'='High_Voltage', 'Texas', 'USA', 'Central Standard Time'
                'I2'='I2(Irving)', 'Texas', 'USA', 'Central Standard Time'
                'IP'='InterNap', 'Texas', 'USA', 'Central Standard Time'
                'KE'='Kilby_East', 'Texas', 'USA', 'Central Standard Time'
                'KW'='Kilby_West', 'Texas', 'USA', 'Central Standard Time'
                'LE'='Lewisville', 'Texas', 'USA', 'Central Standard Time'
                'MG'='Morgan_Semi', 'Texas', 'USA', 'Central Standard Time'
                'NB'='North_Bldg', 'Texas', 'USA', 'Central Standard Time'
                'PH'='Padhu_Home', 'Texas', 'USA', 'Central Standard Time'
                'RE'='Research_East', 'Texas', 'USA', 'Central Standard Time'
                'RF'='RichardsnFAB', 'Texas', 'USA', 'Central Standard Time'
                'RT'='RFAB_Admin', 'Texas', 'USA', 'Central Standard Time'
                'SB'='South_Bldg', 'Texas', 'USA', 'Central Standard Time'
                'SC'='SC_Bldg', 'Texas', 'USA', 'Central Standard Time'
                'SH'='Sherman', 'Texas', 'USA', 'Central Standard Time'
                'SL'='Sugarland', 'Texas', 'USA', 'Central Standard Time'
                'SS'='Expy-Securty', 'Texas', 'USA', 'Central Standard Time'
                'T1'='Expy-TimeBlg', 'Texas', 'USA', 'Central Standard Time'
                'TR'='Tower_Bldg', 'Texas', 'USA', 'Central Standard Time'
                'TX'='Expy-Texins', 'Texas', 'USA', 'Central Standard Time'
                'UA'='Austin-Unitrd', 'Texas', 'USA', 'Central Standard Time'
                'V0'='ATT-Corp', 'Texas', 'USA', 'Central Standard Time'
                'VG'='Vanguard_Ren', 'Texas', 'USA', 'Central Standard Time'
                'WC'='WWCC', 'Texas', 'USA', 'Central Standard Time'
                'XK'='Nokia(Irving)', 'Texas', 'USA', 'Central Standard Time'
                'ZW'='ECOMM_Spares', 'Texas', 'USA', 'Central Standard Time'
                'ZX'='USA_Surplus', 'Texas', 'USA', 'Central Standard Time'
                'ZZ'='Remote_Stock', 'Texas', 'USA', 'Central Standard Time'
                'S4'='Redmond', 'Washington', 'USA', 'Pacific Standard Time'
                'WT'='Federal_Way', 'Washington', 'USA', 'Pacific Standard Time'
                'BO'='Brookfield', 'Wisconsin', 'USA', 'Central Standard Time'
				'LF'='Lehi', 'Utah', 'USA', 'Mountain Standard Time'

    }

    If ( $Site2TZmap.ContainsKey($TIsitecode) ) { return (($Site2TZmap.($TIsitecode))[3]) }
    }
catch{Write-Warning "$($_.Exception.Message)"}
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

$NewTZ = Get-TimeZone $pcsitecode

$CurrentTZ = tzutil /g

#set time zone
Try {
    tzutil /s "$NewTZ"
    if ( $LastExitCode -eq "0") { Write-Host "$currenttime Timezone updated from $CurrentTZ to $NewTZ" }
        
} Catch { Write-Warning "$($_.Exception.Message)" }


Write-host "$currenttime Ended --- $PSCommandPath"
Stop-Transcript 