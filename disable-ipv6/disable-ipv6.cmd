@ECHO OFF
COLOR 1f

REM ********************************************************
REM  TITLE:    Disable-IPv6
REM  AUTHOR:   Levon Becker
REM  VERSION:  1.0.0
REM  DATE:     03/05/2012
REM  LINK:     http://www.bonusbits.com/wiki/HowTo:Disable_IPv6_on_Windows_with_Batch_Script
REM ********************************************************

:VARIABLES
REM ********************************************************
SET REGKEY=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters
SET VALUENAME=DisableComponents
SET VALUEDATA=0xffffffff
REM ********************************************************

:START
ECHO.
ECHO    CHECK FOR TCPIP6 PARAMETERS KEY...
ECHO.
REM CHECK FOR TCPIP6 PARAMETERS KEY
REM CREATE IF MISSING
REM ********************************************************
REG QUERY %REGKEY% > NUL: 2>&1
IF NOT %ERRORLEVEL%==0 (
        ECHO    ADDING REGISTRY KEY
        REG ADD %REGKEY%
) ELSE (
        ECHO    Registry key present.
)

ECHO.
ECHO    CHECKING DISABLE COMPONENTS VALUE...
ECHO.
REM CHECK FOR VALUE NAME + DATA
REM CREATE IF MISSING
REM ********************************************************
REG QUERY %REGKEY%\%VALUENAME% /f %VALUEDATA% > NUL: 2>&1
IF NOT %ERRORLEVEL%==0 (
        ECHO    REGISTRY VALUE OR DATA MISSING OR INCORRECT.
        ECHO    ADDING REGISTRY VALUE PLUS SETTING VALUE DATA...
        ECHO.
        REG ADD %REGKEY% /t REG_DWORD /v %VALUENAME% /d %VALUEDATA% /f
) ELSE (
        ECHO    Registry value present and correct.
)
ECHO.
PAUSE

:END
exit