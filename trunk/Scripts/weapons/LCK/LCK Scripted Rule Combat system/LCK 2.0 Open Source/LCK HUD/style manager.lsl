12&SUBSYS_6666105B

[AC97AUD]
AlsoInstall=KS.Registration(ks.inf), WDMAUDIO.Registration(wdmaudio.inf)
CopyFiles=AC97AUD.CopyList, ALCAUD_SMAPP.CopyList, ALCAUD_CPL.CopyList, RTLCPAPI.CopyList, RTUninstall_SMAPP.CopyList
DelReg=SndVol32.DelReg
AddReg=AC97AUD.AddReg, AC97AUD_NAMES.AddReg, AC97AUD_OEM.AddReg, ALCAUD_SMAPP.AddReg, RTDS3DConfiguration.AddReg, RTLCPAPI.AddReg, RTUninstall_SMAPP.AddReg

[AC97VIA]
AlsoInstall=KS.Registration(ks.inf), WDMAUDIO.Registration(wdmaudio.inf)
CopyFiles=AC97AUD.CopyList, ALCAUD_SMAPP.CopyList, ALCAUD_CPL.CopyList, RTLCPAPI.CopyList, RTUninstall_SMAPP.CopyList
DelReg=SndVol32.DelReg
AddReg=AC97AUD.AddReg, AC97AUD_NAMES.AddReg, AC97AUD_OEM.AddReg, ALCAUD_SMAPP.AddReg, RTDS3DConfiguration.AddReg, RTLCPAPI.AddReg, RTUninstall_SMAPP.AddReg
DelReg=AC97AUD.DelReg

[AC97AUD.DelReg]
HKLM,Enum\Root\*PNPB002
HKLM,Enum\Root\*PNPB006
HKLM,Enum\Root\*PNPB02F

[SndVol32.DelReg]
HKCU,Software\Microsoft\Windows\CurrentVersion\Applets\Volume Control\Realtek AC97 Audio
HKR,Settings
HKLM,%AUTORUN%,SoundMan,,"SOUNDMAN.EXE"
HKLM,Software\RealTek,InitLang
HKLM,Software\RealTek\InitAP
HKCU,Software\Realtek\AC97 Audio

[AC97AUD.CopyList]
ALCXWDM.SYS

[ALCAUD_SMAPP.CopyList]
SOUNDMAN.EXE

[RTUninstall_SMAPP.CopyList]
Alcrmv.exe

[ALCAUD_CPL.CopyList]
ALSNDMGR.CPL
ALSNDMGR.WAV
RTLCPL.EXE

[RTLCPAPI.CopyList]
RTLCPAPI.dll

[RTLCPAPI.AddReg]
HKCR,RtlCP.RtlCP.1,,0,"RtlCP Class"
HKCR,RtlCP.RtlCP.1\CLSID,,0,%RTLCPAPI_CLSID%
HKCR,RtlCP.RtlCP,,0,"RtlCP Class"
HKCR,RtlCP.RtlCP\CurVer,,0,"RtlCP.RtlCP.1"
HKCR,CLSID\%RTLCPAPI_CLSID%,,0,"RtlCP Class"
HKCR,CLSID\%RTLCPAPI_CLSID%\ProgID,,0,"RtlCP.RtlCP.1"
HKCR,CLSID\%RTLCPAPI_CLSID%\VersionIndependentProgID,,0,"RtlCP.RtlCP"
HKCR,CLSID\%RTLCPAPI_CLSID%\Programmable
HKCR,CLSID\%RTLCPAPI_CLSID%\InProcServer32,,0,RTLCPAPI.dll
HKCR,CLSID\%RTLCPAPI_CLSID%\InProcServer32,ThreadingModel,0,Apartment

[CPL_Class.AddReg]
HKLM,%CPL_CLASS_S%,%CPL_CLASS_KS%,0x00010001 ,0x00000004

[RTDS3DConfiguration.AddReg]
HKR,DS3D,ForwardSpeakerConfiguration,0x00010001,1
HKR,DS3D,IgnoreDSSpeakerConfiguration,0x00010001,1

[AC97AUD.Interfaces]
AddInterface=%KSCATEGORY_AUDIO%,%KSNAME_Wave%,AC97AUD.Interface.Wave
AddInterface=%KSCATEGORY_RENDER%,%KSNAME_Wave%,AC97AUD.Interface.Wave
AddInterface=%KSCATEGORY_CAPTURE%,%KSNAME_Wave%,AC97AUD.Interface.Wave
AddInterface=%KSCATEGORY_AUDIO%,%KSNAME_Topology%,AC97AUD.Interface.Topology

[AC97VIA.Interfaces]
AddInterface=%KSCATEGORY_AUDIO%,%KSNAME_Wave%,AC97AUD.Interface.Wave
AddInterface=%KSCATEGORY_RENDER%,%KSNAME_Wave%,AC97AUD.Interface.Wave
AddInterface=%KSCATEGORY_CAPTURE%,%KSNAME_Wave%,AC97AUD.Interface.Wave
AddInterface=%KSCATEGORY_AUDIO%,%KSNAME_Topology%,AC97AUD.Interface.Topology
AddInterface=%KSCATEGORY_AUDIO%,%KSNAME_UART%,AC97AUD.Interface.Uart
AddInterface=%KSCATEGORY_RENDER%,%KSNAME_UART%,AC97AUD.Interface.Uart
AddInterface=%KSCATEGORY_CAPTURE%,%KSNAME_UART%,AC97AUD.Interface.Uart

[AC97AUD.Interface.Wave]
AddReg=AC97AUD.I.Wave.AddReg

[AC97AUD.I.Wave.AddReg]
HKR,,CLSID,,%Proxy.CLSID%
HKR,,FriendlyName,,%AC97AUD.Wave.szPname%

[AC97AUD.Interface.Topology]
AddReg=AC97AUD.I.Topo.AddReg

[AC97AUD.I.Topo.AddReg]
HKR,,CLSID,,%Proxy.CLSID%
HKR,,FriendlyName,,%AC97AUD.Topo.szPname%

[AC97AUD.Interface.Uart]
AddReg=AC97AUD.I.Uart.AddReg

[AC97AUD.I.Uart.AddReg]
HKR,,CLSID,,%Proxy.CLSID%
HKR,,FriendlyName,,%AC97AUD.Uart.szPname%

[AC97AUD.AddReg]
HKR,,AssociatedFilters,,"wdmaud,swmidi,redbook"
HKR,,Driver,,ALCXWDM.SYS
HKR,,NTMPDriver,,"ALCXWDM.SYS,sbemul.sys"
HKR,Drivers,SubClasses,,"wave,midi,mixer"
HKR,Drivers\wave\wdmaud.drv,Driver,,wdmaud.drv
HKR,Drivers\midi\wdmaud.drv,Driver,,wdmaud.drv
HKR,Drivers\mixer\wdmaud.drv,Driver,,wdmaud.drv
HKR,Drivers\wave\wdmaud.drv,Description,,%ALCAUD.Desc%
HKR,Drivers\midi\wdmaud.drv, Description,,%ALCAUD.Desc%
HKR,Drivers\mixer\wdmaud.drv,Description,,%ALCAUD.Desc%

[ALCAUD_SMAPP.AddReg]
HKLM,%AUTORUN%,SoundMan,,"SOUNDMAN.EXE"

[RTUninstall_SMAPP.AddReg]
HKLM,%RT_UNINSTALL%,DisplayName,,"Realtek AC'97 Audio"
HKLM,%RT_UNINSTALL%,UninstallString,,"Alcrmv.exe -r -m"

[AC97AUD.Services]
AddService = ALCXWDM, 0x00000002, AC97AUD_Service_Inst

[AC97VIA.Services]
AddService = ALCXWDM, 0x00000002, AC97AUD_Service_Inst

[AC97AUD_Service_Inst]
DisplayName   = %AC97AUD.SvcDesc%
ServiceType   = 1                  ; SERVICE_KERNEL_DRIVER
StartType     = 3                  ; SERVICE_DEMAND_START
ErrorControl  = 1                  ; SERVICE_ERROR_NORMAL
ServiceBinary = %10%\system32\drivers\ALCXWDM.SYS

[AC97AUD_NAMES.AddReg]
;; Pins
HKLM,%MCat%\%GUID.WaveOut%,Name,,%Pin.WaveOut%
HKLM,%MCat%\%GUID.WaveOut%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.PcBeep%,Name,,%Pin.PcBeep%
HKLM,%MCat%\%GUID.PcBeep%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Phone%,Name,,%Pin.Phone%
HKLM,%MCat%\%GUID.Phone%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Mic%,Name,,%Pin.Mic%
HKLM,%MCat%\%GUID.Mic%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.LineIn%,Name,,%Pin.LineIn%
HKLM,%MCat%\%GUID.LineIn%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.CD%,Name,,%Pin.CD%
HKLM,%MCat%\%GUID.CD%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Video%,Name,,%Pin.Video%
HKLM,%MCat%\%GUID.Video%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Aux%,Name,,%Pin.Aux%
HKLM,%MCat%\%GUID.Aux%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Aux2%,Name,,%Pin.Aux2%
HKLM,%MCat%\%GUID.Aux2%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Radio%,Name,,%Pin.Radio%
HKLM,%MCat%\%GUID.Radio%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.StereoMic%,Name,,%Pin.StereoMic%
HKLM,%MCat%\%GUID.StereoMic%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.MasterOut%,Name,,%Pin.MasterOut%
HKLM,%MCat%\%GUID.MasterOut%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.HeadPhoneOut%,Name,,%Pin.HeadPhoneOut%
HKLM,%MCat%\%GUID.HeadPhoneOut%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.MonoOut%,Name,,%Pin.MonoOut%
HKLM,%MCat%\%GUID.MonoOut%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.WaveIn%,Name,,%Pin.WaveIn%
HKLM,%MCat%\%GUID.WaveIn%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.MicIn%,Name,,%Pin.MicIn%
HKLM,%MCat%\%GUID.MicIn%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Spdif%,Name,,%Pin.Spdif%
HKLM,%MCat%\%GUID.Spdif%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Front_TV%,Name,,%Pin.Front_TV%
HKLM,%MCat%\%GUID.Front_TV%,Display,1,00,00,00,00
HKLM,%MCat%\%GUID.Front_LineIn%,Name,,%Pin.Front_LineIn%
HKLM,%MCat%\%GUID.Front_LineIn%,Display,1,00,00,00,00
HKLM,%MCa