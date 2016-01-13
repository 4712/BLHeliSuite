@ECHO off
@ECHO ***** Batch file for SK Bootloader(from 4712)  v.1             *****
@ECHO ***** All Messages will be saved to MakeSKBootloader_Result.txt *****
@ECHO ***** Start compile with any key  - CTRL-C to abort            *****
Break ON
@pause
DEL MakeSKBootloader_Result.txt /Q

rem ***** Adapt settings to your enviroment ****
DEL Output\Hex\*.hex /Q
DEL Output\Hex\SKBootloader.rc /Q
MKDIR Output
MKDIR Output\Hex
rem SET AtmelPath=C:\Atmel\avrassembler
SET AtmelPath="C:\Dev\Atmel\AVR Tools\AvrAssembler2"

@ECHO Path for Atmel assembler: %AtmelPath% >> MakeSKBootloader_Result.txt
@ECHO Start compile ..... >> MakeSKBootloader_Result.txt

SET NAME=SkBoot_m8
call :add_freq
SET NAME=SkBoot_m168
call :add_freq
SET NAME=SkBoot_m168PA
call :add_freq
goto end

:add_freq
SET FREQ=_8
call :add_pin
SET FREQ=_16
call :add_pin
goto :eof

:add_pin
SET PIN=_PB0
call :compile
SET PIN=_PB4
call :compile
SET PIN=_PD2
call :compile
SET PIN=_PD5
call :compile
goto :eof

goto :end

:compile
SET BOOTL=%NAME%%FREQ%%PIN%
@ECHO compiling %BOOTL% 
@ECHO. >> MakeSKBootloader_Result.txt
@ECHO *****************************************************  >> MakeSKBootloader_Result.txt
@ECHO %BOOTL%  >> MakeSKBootloader_Result.txt
@ECHO *****************************************************  >> MakeSKBootloader_Result.txt
%AtmelPath%\avrasm2.exe -fI -D%NAME% -D%FREQ% -D%PIN% -o "Output\Hex\%BOOTL%.HEX" SKBootloader.asm >> MakeSKBootloader_Result.txt
@ECHO. >> MakeSKBootloader_Result.txt
@ECHO %BOOTL% RCDATA "%BOOTL%.hex" >> Output\Hex\SKBootloader.rc
goto :eof

:end
@pause
exit