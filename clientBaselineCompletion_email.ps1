<#
 Completion.Email.Baseline.Update.Pack.ps1
 
 Sends notices about baseline udpate completion

 Created:  Prakash (Feb 2017)
 
 #>
 
$ErrorActionPreference = "SilentlyContinue"
#Start-Sleep -Seconds 2700
$requesteremail = 'win-clientbaselineowners@list.ti.com'
#$Log = "C:\Logs\Email.Notice.Update.Pack.v6.3.0.4.log"
$Log = "C:\Logs\" + $MyInvocation.MyCommand.Name + ".log"
#$BuildStarted = gc C:\Logs\BaselineUpdate.start.log
#$BuildCompleted = gc C:\Logs\BaselineUpdate.end.log
#$BuildDuration = New-TimeSpan -Start $BuildStarted -End $BuildCompleted
#$BuildDurationDays = $BuildDuration.Days
#$BuildDurationHours = $BuildDuration.Hours
#$BuildDurationMinutes = $BuildDuration.Minutes
function get-DL($scode) {
    $DLmap = @{
'AN'='Xian',  'China',  'Asia',  'chengdu-helpdesk@list.ti.com'
'CC'='Chengdu',  'China',  'Asia',  'chengdu-helpdesk@list.ti.com'
'BJ'='Beijing_Des',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'CD'='Chengdu_Sales',  'China',  'Asia',  'chengdu-helpdesk@list.ti.com'
'CG'='Chongquing',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'CS'='Changsha',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'DO'='Dong_Guan',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'GZ'='Guangzhou',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'HA'='Hangzhou',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'HB'='Shanghai_Lab',  'China',  'Asia',  'shanghaiithelpdesk@list.ti.com'
'HD'='Shanghai_PDC',  'China',  'Asia',  'shanghaiithelpdesk@list.ti.com'
'HK'='HongKong',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'HP'='Shanghai_Des',  'China',  'Asia',  'shanghaiithelpdesk@list.ti.com'
'HU'='Shanghai',  'China',  'Asia',  'shanghaiithelpdesk@list.ti.com'
'HZ'='Shenzhen',  'China',  'Asia',  'shenzhenithelpdesk@list.ti.com'
'J2'='JCAP_AT',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'JC'='Jiangsu',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'MI'='SMIC_Beijing',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'MS'='SMIC_Shanghai',  'China',  'Asia',  'shanghaiithelpdesk@list.ti.com'
'NA'='Nanjing',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'QH'='HongKg(colo)',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'S5'='Sumida_Eltrc',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'SJ'='Suzhou',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'TD'='Qingdao',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'V5'='TATA-CEC',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'V7'='Verizon-MFG',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'WH'='Wuhan',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'XY'='Xiamen',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'ZA'='Asia_Surplus',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'ZI'='Zhuhai',  'China',  'Asia',  'win-clientbaseline@list.ti.com'
'BD'='Bangalore',  'India',  'Asia',  'l2-wintel@list.ti.com'
'LV'='Lakeview',  'India',  'Asia',  'l2-wintel@list.ti.com'
'CX'='Concentrix',  'India',  'Asia',  'l2-wintel@list.ti.com'
'ID'='New_Delhi',  'India',  'Asia',  'l2-wintel@list.ti.com'
'IE'='Pune',  'India',  'Asia',  'l2-wintel@list.ti.com'
'WP'='Wipro',  'India',  'Asia',  'l2-wintel@list.ti.com'
'A2'='ANAM',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'AK'='Kor-Ardentec',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'CK'='ChangWon',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'EK'='Sejong_Sales',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'KD'='Daegu_City',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'S9'='Suwon',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'SE'='Seoul',  'Korea',  'Asia',  'win-clientbaseline@list.ti.com'
'KL'='Kuala_Lumpur',  'Malaysia',  'Asia',  'microbumi@list.ti.com'
'M8'='Penang',  'Malaysia',  'Asia',  'win-clientbaseline@list.ti.com'
'MK'='Malacca',  'Malaysia',  'Asia',  'tiem-clientsupport@list.ti.com'
'BA'='Baguio',  'Philippines',  'Asia',  'tipi-itwc@list.ti.com'
'CL'='Clark_AT',  'Philippines',  'Asia',  'ticl-ithw@list.ti.com'
'P6'='Manila(BB)',  'Philippines',  'Asia',  'win-clientbaseline@list.ti.com'
'P7'='Rosephil(BB)',  'Philippines',  'Asia',  'win-clientbaseline@list.ti.com'
'GF'='Singapore_PDC',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'GH'='Singapore_EXT',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'QS'='Singap(colo)',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'S0'='ST_Assm/Tst',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'TJ'='SingTechJV',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'UB'='Singapore_GDC',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'UE'='SingaporeAPR',  'Singapore',  'Asia',  'sgosd@list.ti.com'
'A1'='Hsinchu_Sales',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'AR'='Ardentec(FAB)',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'I1'='IST(A/T)',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'KS'='Taiwan_Sales',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'LS'='Lingsen(A/T)',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'TA'='ChungHo',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'TE'='ChungHo_T2',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'TH'='Taipei',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'TK'='Amkor(DLP)',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'TP'='Taiwan_PDC',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'TQ'='TaichungSales',  'Taiwan',  'Asia',  'thcs@list.ti.com'
'AI'='Millennium',  'Thailand',  'Asia',  'win-clientbaseline@list.ti.com'
'BX'='Alpha_Ventr',  'Thailand',  'Asia',  'win-clientbaseline@list.ti.com'
'S6'='Sumida',  'Thailand',  'Asia',  'win-clientbaseline@list.ti.com'
'TI'='Hana',  'Thailand',  'Asia',  'win-clientbaseline@list.ti.com'
'S3'='Austr-Xpedr',  'Australia',  'Australia',  'win-clientbaseline@list.ti.com'
'VN'='Vienna',  'Austria',  'Europe',  'win-clientbaseline@list.ti.com'
'XM'='MMS_Sofia',  'Bulgaria',  'Europe',  'win-clientbaseline@list.ti.com'
'PG'='Prague',  'Czechosl',  'Europe',  'win-clientbaseline@list.ti.com'
'X0'='EEPIC_Prague',  'Czechosl',  'Europe',  'win-clientbaseline@list.ti.com'
'EU'='London',  'England',  'Europe',  'win-clientbaseline@list.ti.com'
'M6'='ManchesterGB',  'England',  'Europe',  'win-clientbaseline@list.ti.com'
'NT'='Northampton',  'England',  'Europe',  'win-clientbaseline@list.ti.com'
'V1'='Verizon-Corp',  'England',  'Europe',  'win-clientbaseline@list.ti.com'
'V2'='TATA-Corp',  'England',  'Europe',  'win-clientbaseline@list.ti.com'
'TL'='Tallinn',  'Estonia',  'Europe',  'win-clientbaseline@list.ti.com'
'HE'='Helsinki',  'Finland',  'Europe',  'win-clientbaseline@list.ti.com'
'OF'='Oulu(SVA)',  'Finland',  'Europe',  'win-clientbaseline@list.ti.com'
'BB'='Boulogne',  'France',  'Europe',  'win-clientbaseline@list.ti.com'
'LY'='Lyon',  'France',  'Europe',  'win-clientbaseline@list.ti.com'
'EZ'='EMEA_Show',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'FR'='Freising',  'Germany',  'Europe',  'tid_it_ehd@list.ti.com'
'GA'='Garching',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'GB'='FilderstadtBB',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'GE'='Eschborn',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'H0'='Hannovr_Sales',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'MN'='Munich_Airpt',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'QF'='Frankft(colo)',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'RG'='Rattingen',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'ZE'='EMEA_Surplus',  'Germany',  'Europe',  'win-clientbaseline@list.ti.com'
'BU'='Budapest',  'Hungary',  'Europe',  'win-clientbaseline@list.ti.com'
'CO'='Cork',  'Ireland',  'Europe',  'win-clientbaseline@list.ti.com'
'IS'='Raanana',  'Israel',  'Europe',  'win-clientbaseline@list.ti.com'
'XJ'='Talpiot',  'Israel',  'Europe',  'win-clientbaseline@list.ti.com'
'CI'='Catania',  'Italy',  'Europe',  'win-clientbaseline@list.ti.com'
'IF'='Florence',  'Italy',  'Europe',  'win-clientbaseline@list.ti.com'
'M2'='Milan(SVA)',  'Italy',  'Europe',  'win-clientbaseline@list.ti.com'
'ML'='Milan',  'Italy',  'Europe',  'win-clientbaseline@list.ti.com'
'EI'='Eindhoven',  'Netherlands',  'Europe',  'win-clientbaseline@list.ti.com'
'U2'='Utrecht_PDC',  'Netherlands',  'Europe',  'win-clientbaseline@list.ti.com'
'OS'='Oslo',  'Norway',  'Europe',  'win-clientbaseline@list.ti.com'
'WA'='Warszawa',  'Poland',  'Europe',  'win-clientbaseline@list.ti.com'
'XF'='NoBug-Bchr',  'Romania',  'Europe',  'win-clientbaseline@list.ti.com'
'MR'='Moscow',  'Russia',  'Europe',  'win-clientbaseline@list.ti.com'
'SP'='StPetersburg',  'Russia',  'Europe',  'win-clientbaseline@list.ti.com'
'GR'='Greenock',  'Scotland',  'Europe',  'win-clientbaseline@list.ti.com'
'XN'='Belgrade',  'Serbia',  'Europe',  'win-clientbaseline@list.ti.com'
'MA'='Madrid',  'Spain',  'Europe',  'win-clientbaseline@list.ti.com'
'GG'='Gothenburg',  'Sweden',  'Europe',  'win-clientbaseline@list.ti.com'
'L7'='Lund',  'Sweden',  'Europe',  'win-clientbaseline@list.ti.com'
'SM'='Stockholm',  'Sweden',  'Europe',  'win-clientbaseline@list.ti.com'
'ZU'='Zurich',  'Switzerland',  'Europe',  'win-clientbaseline@list.ti.com'
'TU'='Istanbul',  'Turkey',  'Europe',  'win-clientbaseline@list.ti.com'
'AJ'='Aizu',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'D1'='Densen-Kits',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'GO'='Nakaya',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'HH'='Kyuko-Hiji',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'HI'='Hiji',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'HJ'='Hiji-PAC',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'HT'='Kumamoto(SEC)',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'JF'='Fujiwara',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'JH'='Kyuko-Hiji',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'JR'='Renesas-HC',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'K2'='KitsukiTakaki',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'KK'='HijiSubcon',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'KT'='Kobe',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'KY'='Kyoto',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'M0'='Matsumoto',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'MH'='Miho',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'NN'='Nagoya',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'OA'='Osaka',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'QJ'='Tokyo(colo)',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'RH'='Rhythm',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'SI'='Saitama',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'T2'='Fujiwara2',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'TS'='Tokyo',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'TZ'='Takashima',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'V6'='KDDI-Japan',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'V8'='China-Telecom',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'V9'='Japan-PEther',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'YA'='TICT_Yatabe',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'YO'='Yokohama',  'Japan',  'Japan',  'japan-deskside@list.ti.com'
'MQ'='Montreal',  'Canada',  'NorthAm','ClientbaselineNAmerica@list.ti.com'
'OT'='Ottawa',  'Canada',  'NorthAm','ClientbaselineNAmerica@list.ti.com'
'TM'='Mississauga',  'Canada',  'NorthAm','ClientbaselineNAmerica@list.ti.com'
'TO'='Toronto_Des',  'Canada',  'NorthAm','ClientbaselineNAmerica@list.ti.com'
'AO'='Aguas',  'Mexico',  'NorthAm',  'tmg_tmxinfra@list.ti.com'
'GJ'='Guadalajara',  'Mexico',  'NorthAm',  'tmg_tmxinfra@list.ti.com'
'MP'='Mexico_PDC',  'Mexico',  'NorthAm',  'tmg_tmxinfra@list.ti.com'
'QW'='Aguas-QSMWH',  'Mexico',  'NorthAm',  'tmg_tmxinfra@list.ti.com'
'WE'='Dextra-Aguas',  'Mexico',  'NorthAm',  'tmg_tmxinfra@list.ti.com'
'B2'='Sao_Paulo',  'Brazil',  'SouthAm','ClientbaselineNAmerica@list.ti.com'
'HV'='Huntsville',  'Alabama',  'USA','ClientbaselineNAmerica@list.ti.com'
'AZ'='Tucson_HBA_2b',  'Arizona',  'USA','ClientbaselineNAmerica@list.ti.com'
'CR'='Chandler',  'Arizona',  'USA','ClientbaselineNAmerica@list.ti.com'
'TC'='Tucson_HPA',  'Arizona',  'USA','ClientbaselineNAmerica@list.ti.com'
'C4'='SBarbra(Spec)',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'C5'='Grass_Valley',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'IV'='Irvine',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'LA'='Los_Angeles',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'NS'='Santa_Clara',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'SF'='San_Francisco',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'SG'='Sunnyvale',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'SO'='Sorrento-SD',  'California',  'USA','ClientbaselineNAmerica@list.ti.com'
'DS'='Broomfield',  'Colorado',  'USA','ClientbaselineNAmerica@list.ti.com'
'FT'='Ft_Collins',  'Colorado',  'USA','ClientbaselineNAmerica@list.ti.com'
'LC'='Longmont(SVA)',  'Colorado',  'USA','ClientbaselineNAmerica@list.ti.com'
'DC'='WashingtonDC',  'DistrictC',  'USA','ClientbaselineNAmerica@list.ti.com'
'BC'='Boca_Raton',  'Florida',  'USA','ClientbaselineNAmerica@list.ti.com'
'AT'='Atlanta',  'Georgia',  'USA','ClientbaselineNAmerica@list.ti.com'
'NG'='Norcross_Des',  'Georgia',  'USA','ClientbaselineNAmerica@list.ti.com'
'PT'='Warrenville',  'Illinois',  'USA','ClientbaselineNAmerica@list.ti.com'
'S8'='Schaumburg',  'Illinois',  'USA','ClientbaselineNAmerica@list.ti.com'
'CE'='Carmel',  'Indiana',  'USA','ClientbaselineNAmerica@list.ti.com'
'ME'='Portland',  'Maine',  'USA','ClientbaselineNAmerica@list.ti.com'
'GM'='Germantown',  'Maryland',  'USA','ClientbaselineNAmerica@list.ti.com'
'WM'='Waltham',  'Massachuss',  'USA','ClientbaselineNAmerica@list.ti.com'
'SD'='Southfield',  'Michigan',  'USA','ClientbaselineNAmerica@list.ti.com'
'BM'='Bloomington',  'Minnesota',  'USA','ClientbaselineNAmerica@list.ti.com'
'S2'='St_Charles',  'Missouri',  'USA','ClientbaselineNAmerica@list.ti.com'
'MY'='Manchester',  'NewHampshire',  'USA','ClientbaselineNAmerica@list.ti.com'
'IN'='Iselin',  'NewJersey',  'USA','ClientbaselineNAmerica@list.ti.com'
'PF'='Pittsfd_Sales',  'NewYork',  'USA','ClientbaselineNAmerica@list.ti.com'
'CN'='Cary_Design',  'NorthCarol',  'USA','ClientbaselineNAmerica@list.ti.com'
'BV'='Beaverton',  'Oregon',  'USA','ClientbaselineNAmerica@list.ti.com'
'BE'='Bethlehem',  'Pennsylvania',  'USA','ClientbaselineNAmerica@list.ti.com'
'RD'='Warwick',  'RhodeIsland',  'USA','ClientbaselineNAmerica@list.ti.com'
'KN'='Knoxville',  'Tennessee',  'USA','ClientbaselineNAmerica@list.ti.com'
'A6'='ATS-Dal',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'AA'='LvlI-Dal',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'AF'='Austin_Sales',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'AW'='Amazon_Web',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'BT'='Brit_Telcomm',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'CA'='Change(ADS)',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'CH'='Expy-Chemcal',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'CQ'='Expy-CUP',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'CU'='CreditUnion',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'D5'='DMOS5-DA',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'D6'='DMOS6-DA',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'D9'='RES_Lewallen',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'DA'='Dallas',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'DE'='Dallas_East',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'DF'='DFW',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'DK'='Expwy-DCON',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'DR'='DRP_Hotsite',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'DX'='DA-Scada',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'EE'='Alliance_FW',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'ES'='Expy-HazStg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'EX'='Exec_Mobile',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'EY'='Ernst_Young',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'FD'='Floyd_Rd',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'FE'='Expy-FleetMg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'FL'='Forest_Lane',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'FN'='Floyd_Rd_N',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'FO'='McKin-FlOps',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'G1'='Hyatt_Regncy',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'G4'='4G-LTE',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'HM'='Expy-Hazmat',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'HS'='Houston_Sales',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'HX'='High_Voltage',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'I2'='I2(Irving)',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'IP'='InterNap',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'KE'='Kilby_East',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'KW'='Kilby_West',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'LE'='Lewisville',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'MG'='Morgan_Semi',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'NB'='North_Bldg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'PH'='Padhu_Home',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'RE'='Research_East',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'RF'='RichardsnFAB',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'RT'='RFAB_Admin',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'SB'='South_Bldg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'SC'='SC_Bldg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'SH'='Sherman',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'SL'='Sugarland',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'SS'='Expy-Securty',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'T1'='Expy-TimeBlg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'TR'='Tower_Bldg',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'TX'='Expy-Texins',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'UA'='Austin-Unitrd',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'V0'='ATT-Corp',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'VG'='Vanguard_Ren',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'WC'='WWCC',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'XK'='Nokia(Irving)',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'ZW'='ECOMM_Spares',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'ZX'='USA_Surplus',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'ZZ'='Remote_Stock',  'Texas',  'USA','ClientbaselineNAmerica@list.ti.com'
'S4'='Redmond',  'Washington',  'USA','ClientbaselineNAmerica@list.ti.com'
'WT'='Federal_Way',  'Washington',  'USA','ClientbaselineNAmerica@list.ti.com'
'BO'='Brookfield',  'Wisconsin',  'USA','ClientbaselineNAmerica@list.ti.com'
'LF'='Lehi',  'Utah',  'USA',  'lfab_it_fs@list.ti.com'


    }
    If ( $DLmap.ContainsKey($scode) ) { 
 
        return (($DLmap.($scode))[3])

    }
}

 $global:pctype=(Get-WmiObject -Class win32_computersystem).pcsystemtype

<#if($pctype -eq 2){
 $textfile=get-content -path "C:\ProgramData\TIlogs\attributeLogFile.txt"
 if($textfile -contains "Success.."){
 $message="Wifi MAC attributes are updated"
 }
 else
 {
 $message="Reach out to 'Win-clientbaseline@list.ti.com' to get the wifi attributes updated for the wifi connection."
 }}
 elseif($pctype -ne 2) 
 {$message="Not Applicable"}
 <br>`n Wifi_MAC_attributes: $message 
<br>`n ================================================== 
#>

$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
$osmwmi = (Get-WmiObject Win32_PhysicalMemory | measure-object Capacity -sum)
$osbuild = Get-CimInstance -Namespace root/ccm/invagt -ClassName ccm_operatingsystem
$oswmi=(Get-WmiObject -Class win32_oPeratingsystem)
$bioswmi = (Get-WmiObject -Class win32_bios)
$cswmi = (Get-WmiObject -Class win32_computersystem)
$Lenmodel= (Get-WmiObject win32_computersystemproduct)
$servername = $env:computerName
$Fqdn = [System.Net.Dns]::GetHostByName($servername).HostName
$serveros = $oswmi.caption
$osver=$osbuild.BuildExt
$serversp = $oswmi.ServicePackMajorVersion
$servermanu = $cswmi.Manufacturer
$servermodel = $cswmi.Model
$lenovomodel = $Lenmodel.version
$serversn = $bioswmi.serialnumber
$serversmemory = $osmwmi.Sum / 1GB
$serverdescription = $oswmi.Description
$servercpus = $cswmi.NumberOfLogicalProcessors
$serverbios = $bioswmi.SMBIOSBIOSVersion 
$tpmact = (get-tpm).tpmactivated

<#if($pctype -eq 2 -and $tpmact -eq "True"-and $servermanu -ne 'LENOVO' ){
$encryption= "Please keep the machine connected to TI network for ~1 hour and validate if the recovery key is updated in the AD before handing it to the End User. Bitlocker Encryption is in progress."
}
else#>

if($pctype -eq 2 -and $tpmact -eq "True"){
$encryption = "Please reboot the machine keeping it connected to TI network and validate if the recovery key is updated in the AD and registry property of 'HKLM:\Software\TI\BitlockerEncryptionStatus' is FullyEncrypted before handing it to the End User. Bitlocker Encryption is in progress. "
}
elseif($tpmact -ne "True"){
$encryption="TPM not activated"}

<#elseif($pctype -ne 2) 
 {$encryption="Not Applicable"}#>

$nic = gwmi -computer . -class "win32_networkadapterconfiguration" | Where-Object { ($_.defaultIPGateway -ne $null) -and ($_.defaultIPGateway -ne "192.168.1.1" ) -and ($_.DNSDomain -eq "dhcp.ti.com" ) }
$IPaddress = $nic.ipaddress | select-object -first 1
$Region = (get-itemproperty -Path HKLM:\Software\TI\Baseline -Name Region).Region
$country = (get-itemproperty -Path HKLM:\Software\TI\Baseline -Name Country).country
$Sitename = (get-itemproperty -Path HKLM:\Software\TI\Baseline -Name Sitename).Sitename
$Sitecode = (get-itemproperty -Path HKLM:\Software\TI\Baseline -Name Site).Site
$BaselineType=(get-itemproperty -Path HKLM:\Software\TI\Baseline -Name OSDBaseline).OSDBaseline
$TotalTime= (get-itemproperty -Path HKLM:\Software\TI\Baseline -Name TotalMinutes).TotalMinutes

$Converted= New-TimeSpan -Minutes $TotalTime
$TotalMinutes= $converted.TotalMinutes


$macaddress = Get-WmiObject Win32_NetworkAdapterConfiguration 
$body=$macaddress |select Description,Macaddress| ConvertTo-Html -head $header | Out-String

 

$DL = get-DL($Sitecode)

$serverbaselineversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\TI Software Load").imageversion
$InstalledPatches = (get-hotfix | Where-Object { $_.installedon -match (get-date -Format MM/dd/yyy) }) | ConvertTo-Html -head $header | Out-String 
$InstalledSW = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate  |
Where-Object { $_.InstallDate -match (get-date -Format yyyyMMdd) }  | ConvertTo-Html -head $header | Out-String 

Add-Content $Log "Beginning Email creation $buildcompleted"
Add-Content $Log "================================================================="

$AlertSubject = "$servername - Client baseline completed"

$AlertBody = @"

<br>`n Please move this Client to the $sitename OU for the relevant GPOs to be applied so that it is production ready.
<br>`n =========================================================================================

<br>`n Client Information:
<br>`n ==================================================
<br>`n HostName: $servername 
<br>`n Fqdn: $Fqdn 
<br>`n OS: $serveros 
<br>`n OSVersion: $osver
<br>`n Manufacturer: $servermanu 
<br>`n Model: $servermodel 
<br>`n LenovoModel: $lenovomodel
<br>`n Physical Memory: $serversmemory 
<br>`n Bios: $serverbios 
<br>`n Serial: $serversn 
<br>`n BaselineType: $BaselineType 
<br>`n Region: $Region 
<br>`n Country: $country 
<br>`n Sitename: $Sitename 
<br>`n IPAddress: $IPaddress 
<br>`n TPMActivated: $tpmact
<br>`n Bitlocker_Encryption: $encryption


<br>`n ================================================== 

<br>`n MS Patches installed today : $InstalledPatches 
<br>`n Tools/SW installed today : $InstalledSW <br>

<br>`n Mac Address details: <br>

"@

Add-Content $Log $AlertSubject
Add-Content $Log $AlertBody

Try {
	if ([string]::IsNullOrEmpty($DL))
	{
    $DL="win-clientbaseline@list.ti.com" 
    }
	
   Send-MailMessage -From "win-clientbaselineowners@list.ti.com" -Subject $AlertSubject -To $DL -cc "win-clientbaseline@list.ti.com"  -body ($alertbody+$body) -BodyAsHtml  -DeliveryNotificationOption OnFailure -SmtpServer smtp.mail.ti.com
     
}
catch {
    Write-Warning "Exception Type: $($_.Exception.GetType().FullName)" 
    Write-Warning "Exception Message: $($_.Exception.Message)"
}

#function to write log with current date and time
$logpath = 'C:\ProgramData\TILogs\'+($MyInvocation.MyCommand.Name).Trim('.ps1')+'.log'
function writelog
{
    Param([String]$msg)
    $time = (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")
    Add-Content $logpath -value ($msg+" "+$time)
}
writelog "$($($MyInvocation.MyCommand).Name) has been executed succesfully"