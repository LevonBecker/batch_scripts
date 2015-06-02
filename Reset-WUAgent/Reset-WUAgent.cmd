@echo off
cls

REM ==================================================================================
REM DESCRIPTION    : This script resets all of Windows Update Agent settings.
REM AUTHOR         : Luca Fabbri
REM VERSION HISTORY: 2.0 - Start
REM ==================================================================================

@echo 1. Stopping Windows Update, BITS, Application Identity, Cryptographic Services and SMS Host Agent services...
net stop wuauserv
net stop bits
net stop appidsvc
net stop cryptsvc
net stop ccmexec

@echo 2. Checking if services were stopped successfully...
sc query wuauserv | findstr /I /C:"STOPPED"
if %errorlevel% NEQ 0 goto END

sc query bits | findstr /I /C:"STOPPED"
if %errorlevel% NEQ 0 goto END

sc query appidsvc | findstr /I /C:"STOPPED"
if %errorlevel% NEQ 0 sc query appidsvc | findstr /I /C:"OpenService FAILED 1060"
if %errorlevel% NEQ 0 goto END

sc query cryptsvc | findstr /I /C:"STOPPED"
if %errorlevel% NEQ 0 goto END

sc query ccmexec | findstr /I /C:"STOPPED"
if %errorlevel% NEQ 0 sc query ccmexec | findstr /I /C:"OpenService FAILED 1060"
if %errorlevel% NEQ 0 goto END

@echo 3. Deleting AU cache folder and log file...
del /f /q "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"
del /f /s /q %SystemRoot%\SoftwareDistribution\*.*
del /f /s /q %SystemRoot%\system32\catroot2\*.*
del /f /q %SystemRoot%\WindowsUpdate.log

REM @echo 3. Renaming AU cache folder and log file...
REM del /f /q "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"
REM ren %SystemRoot%\SoftwareDistribution *.bak
REM ren %SystemRoot%\system32\catroot2 *.bak
REM ren %SystemRoot%\WindowsUpdate.log *.bak

REM sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
REM sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)

@echo 4. Re-registering DLL files...
cd /d %WinDir%\system32
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s shdocvw.dll
regsvr32.exe /s browseui.dll
regsvr32.exe /s jscript.dll
regsvr32.exe /s vbscript.dll
regsvr32.exe /s scrrun.dll
regsvr32.exe /s msxml.dll
regsvr32.exe /s msxml3.dll
regsvr32.exe /s msxml6.dll
regsvr32.exe /s actxprxy.dll
regsvr32.exe /s softpub.dll
regsvr32.exe /s wintrust.dll
regsvr32.exe /s dssenh.dll
regsvr32.exe /s rsaenh.dll
regsvr32.exe /s gpkcsp.dll
regsvr32.exe /s sccbase.dll
regsvr32.exe /s slbcsp.dll
regsvr32.exe /s cryptdlg.dll
regsvr32.exe /s oleaut32.dll
regsvr32.exe /s ole32.dll
regsvr32.exe /s shell32.dll
regsvr32.exe /s initpki.dll
regsvr32.exe /s wuapi.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll
regsvr32.exe /s qmgr.dll
regsvr32.exe /s qmgrprxy.dll
regsvr32.exe /s wucltux.dll
regsvr32.exe /s muweb.dll
regsvr32.exe /s wuwebv.dll

@echo 5. Removing WSUS Client Id...
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v AccountDomainSid /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v PingID /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /f

@echo 6. Resetting Winsock and WinHTTP Proxy...
netsh winsock reset
proxycfg.exe -d
netsh winhttp reset proxy

@echo 7. Starting SMS Host Agent, Cryptographic Services, Application Identity, BITS, Windows Update services...
net start ccmexec
net start cryptsvc
net start appidsvc
net start bits
net start wuauserv

@echo 8. Deleting all BITS jobs...
bitsadmin.exe /reset /allusers

@echo 9. Forcing AU discovery...
wuauclt /resetauthorization /detectnow

:END