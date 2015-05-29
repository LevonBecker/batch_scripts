@ECHO OFF
COLOR 1f

:HEADER
CLS
ECHO    -------------------------------------------------------------------------------
ECHO    AUTHOR:         Levon Becker
ECHO    TITLE:          Ping-List
ECHO    LAST CHANGE:    04/08/2010
ECHO    VERSION:        1.0.2
ECHO    LINK:           http://www.bonusbits.com/wiki/HowTo:Use_Ping_List_Batch_Script
ECHO    -------------------------------------------------------------------------------
ECHO.
PAUSE

:NOTES
REM     +The text file with your list of hostnames should be named hostlist.txt
REM     +The hostnames can be seperated by a comma or carriage return
REM     +The output file will be a text file named PingResults.txt
REM     +The output file is setup to be comma delimited for easy import to Excel
REM     +Changed output file to be csv

REM Delete the output file if it exists from a previous run.
IF EXIST "PingResults.txt" del /q PingResults.txt

REM Delete the temp file.
IF EXIST "pinglog" del /q pinglog

REM Description Header for top row in Excel
ECHO Hostname,IP from Ping,Ping Status,Data of Ping,Time of Ping > PingResults.csv

REM Pull hostnames from text file until the end of the text file list
for /f "tokens=* delims=," %%I in (Hostlist.txt) do call :sub1 %%I
goto :eof

:sub1

REM Display in the command window which hostname is being processed so we know
REM something is happening.
ECHO    %1

REM Ping the current hostname set as %1 and redirect the output to pinglog file.
ping -a -n 1 -w 500 %1 > pinglog

SET status=UNKNOWN

find /i "unknown host" < pinglog > nul
if not errorlevel 1 set status=UNKNOWN HOST

find /i "could not find host" < pinglog > nul
if not errorlevel 1 set status=HOST NOT FOUND

find /i "reply" < pinglog > nul
if not errorlevel 1 set status=UP

find /i "expired in transit" < pinglog > nul
if not errorlevel 1 set status=EXPIRED IN TRANSIT

find /i "Request timed out" < pinglog > nul
if not errorlevel 1 set status=DOWN

SET PINGIP=NO IP

REM Pull the IP address of the line that has Pinging in it and IP between []
FOR /F "tokens=1,2 delims=[]" %%A IN ('FIND "Pinging" pinglog') DO IF NOT "%%B"=="" SET PINGIP=%%B

REM Append line of gathered information including the hostname from the source.
REM No spaces so it falls into Excel easier
>> PingResults.csv echo %*,%PINGIP%,%status%,%DATE%,%TIME%

REM Delete the temp file.
IF EXIST "pinglog" del /q pinglog

goto :eof

COLOR 1a
CLS
ECHO.
ECHO    *********************************************
ECHO    *********************************************
ECHO    **                                         **
ECHO    **           PROCESS COMPLETED!            **
ECHO    **                                         **
ECHO    ** The Output Filename is PingResults.txt  **
ECHO    **                                         **
ECHO    *********************************************
ECHO    *********************************************
ECHO.
ECHO.
PAUSE

:END
exit