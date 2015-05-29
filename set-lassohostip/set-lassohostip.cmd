@ECHO OFF
COLOR 1f
CLS

REM ********************************************************
REM TITLE: Set-LassoHostIP
REM AUTHOR: Levon Becker
REM VERSION: 1.0.0
REM DATE: 03/12/2012
REM LINK: http://www.bonusbits.com/wiki/HowTo:Use_Batch_Script_to_Set_Lasso_Host_IP
REM ********************************************************

:VARIABLES
SET LASSOPATH="C:\Program Files\LogLogic\Lasso Enterprise"
SET LASSOADM="C:\Program Files\LogLogic\Lasso Enterprise\llwecadm.exe"

:GETHOSTIP
REM GET HOST IP ON 10.10.0.0 NETWORK
@FOR /F "tokens=1,2 delims=:" %%a IN ('ipconfig ^| findstr "IPv4" ^| findstr "10.10"') DO SET IPC=%%b
SET IP=%IPC:~1%
IF %ERRORLEVEL%==0 (
        ECHO    LAN CONNECTION IP: %IP%
) ELSE (
        SET NOTE=FAILED TO GET HOST IP
        GOTO ERROR
)

:GETLASSOHOSTIP1
ECHO.
REM CHECK CURRENT LASSO WEC HOSTIP
CD %LASSOPATH%
@FOR /F "tokens=1,2 delims=:" %%a IN ('llwecadm.exe getwecprops ^| findstr "hostIp"') DO SET WECHOSTIP=%%b
SET LASSOHOSTIP=%WECHOSTIP:~3%
IF %ERRORLEVEL%==0 (
        ECHO    CURRENT LASSO HOSTIP: %LASSOHOSTIP%
) ELSE (
        SET NOTE=FIRST ATTEMPT TO GET LASSO HOSTIP FAILED
        GOTO ERROR
)

:SETLASSOIP
ECHO.
REM SET LASSO WEC HOSTIP IF NEEDED
IF NOT %LASSOHOSTIP%==%IP% (
        ECHO    UPDATING LASSO HOSTIP to %IP%...
        %LASSOADM% setwecprops hostIp %IP% > NUL: 2>&1
) ELSE (
        COLOR 1a
        CLS
        ECHO.
        ECHO    LASSO HOST IP ALREADY CORRECT
        GOTO END
)
IF %ERRORLEVEL%==0 (
        ECHO    UPDATE COMMAND SUCCESSFUL
) ELSE (
        SET NOTE=COULD NOT SET LASSO HOSTIP
        GOTO ERROR
)

:GETLASSOHOSTIP2
ECHO.
REM CHECK CURRENT LASSO WEC HOSTIP
CD %LASSOPATH%
@FOR /F "tokens=1,2 delims=:" %%a IN ('llwecadm.exe getwecprops ^| findstr "hostIp"') DO SET WECHOSTIP=%%b
SET LASSOHOSTIP=%WECHOSTIP:~3%
IF %ERRORLEVEL%==0 (
        ECHO    UPDATED LASSO HOSTIP: %LASSOHOSTIP%
) ELSE (
        SET NOTE=SECOND ATTEMPT TO GET LASSO HOSTIP FAILED
        GOTO ERROR
)

:DETERMINESUCCESS
ECHO.
IF %LASSOHOSTIP%==%IP% (
        COLOR 1a
        CLS
        ECHO.
        ECHO    UPDATED SUCCESSFULLY
        GOTO END
) ELSE (
        SET NOTE=UPDATING LASSO HOSTIP FAILED
        GOTO ERROR
)
        

:ERROR
COLOR 1c
REM CLS
ECHO.
ECHO    ERROR: %NOTE%
ECHO.
PAUSE

:END
REM ECHO.
REM ECHO        COMPLETED
ECHO.
PAUSE
exit