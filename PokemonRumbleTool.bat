@echo off

:: TOOLS NEEDED: wwPacker, U8Tool, LZH8_CmpDec, PKC Decoder, Python 3.12 ::

:: EDIT THESE WITH THE PATHS TO YOUR TOOLS ::

:: __wwunpacker.bat ::
set wwunpacker="path\to\tool"

:: _wwpacker-NoMod.bat ::
set wwpacker="path\to\tool"

:: U8Tool.exe ::
set u8tool="path\to\tool"

:: lzh8_dec.exe ::
set lzh8dec="path\to\tool"

:: lzh8_cmp.exe ::
set lzh8cmp="path\to\tool"

:: PKC Decoder ::
set "pkcdecoder=path\to\tool"

:: Python 3.12 ::
set "python12=path\to\tool"

:: ACTUAL SCRIPT BELOW ::

set input=%1

echo Select Mode. (Pack/Unpack/Decode)
set /p mode=

if /i "%mode%"=="Pack" goto Pack
if /i "%mode%"=="Unpack" goto Unpack
if /i "%mode%"=="Decode" goto Decode

echo Invalid Option.

goto exitPoint

:Pack
:: Check if input is valid
if not exist "%input%" (
	echo ERROR: Invalid Input! [No Input]
	goto exitPoint
) else (
	type "%input%" 1>Nul 2>&1
	if not errorlevel 1 (
		echo ERROR: Invalid Input! [Not A Folder]
		goto exitPoint
	)
)

if not exist %cd%\00000005_app_OUT (
	echo ERROR: 00000005_app_OUT Folder Not Found!
	goto exitPoint
)

if not exist %cd%\rumble_extract (
	echo ERROR: rumble_extract Folder Not Found!
	goto exitPoint
)

echo Packing...

%u8tool% -file %cd%\Modified_Dec_Script.arc.cx -folder %input% -pack

%lzh8cmp% Modified_Dec_Script.arc.cx script.arc.cx

copy script.arc.cx 00000005_app_OUT

%u8tool% -file %cd%\00000005.app -folder %cd%\00000005_app_OUT\ -pack

echo Working...

copy 00000005.app rumble_extract

call %wwpacker% rumble_extract

echo Finished!

goto exitPoint

:Unpack
:: Check if input is valid
if not "%~x1%"==".wad" (
	echo ERROR: Invalid Input! [No Input / Not a WAD File]
	goto exitPoint
)

echo Unpacking...

call %wwunpacker% %input%

if %errorlevel%==14 (
	goto exitPoint
)

echo Working...

ren 0001000157505345 rumble_extract

%u8tool% -file %cd%\rumble_extract\00000005.app -extract

move rumble_extract\00000005_app_OUT %cd%

%lzh8dec% %cd%\00000005_app_OUT\script.arc.cx Dec_script.arc.cx

%u8tool% -file %cd%\Dec_script.arc.cx -extract

ren Dec_script_arc_cx_OUT script_extract

echo Finished!

goto exitPoint

:Decode
:: Check if input is valid
if not exist %input%\ (
	echo ERROR: Invalid Input! [No Input / Not A Folder]
	goto exitPoint
)

echo Decoding...

for %%f in (%input%\*.pkc) do "%python12%" "%pkcdecoder%" %%f > %%f.txt

echo Finished!

goto exitPoint

:exitPoint
pause