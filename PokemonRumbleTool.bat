@echo off

:: TOOLS NEEDED: wwPacker, U8Tool, LZH8_CmpDec ::

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

:: ACTUAL SCRIPT BELOW ::

set input=%1

echo Select Mode. (Pack/Unpack)
set /p mode=

if /i "%mode%"=="Pack" goto Pack
if /i "%mode%"=="Unpack" goto Unpack

echo Invalid Option.

goto exitPoint


:Pack
echo Packing...

%u8tool% -file %cd%\Modified_Dec_Script.arc.cx -folder %input% -pack

%lzh8cmp% Modified_Dec_Script.arc.cx script.arc.cx

copy script.arc.cx 00000005_app_OUT

%u8tool% -file %cd%\00000005.app -folder %cd%\00000005_app_OUT\ -pack

echo Working...

copy 00000005.app rumble_extract

call %wwpacker% rumble_extract

goto exitPoint


:Unpack
echo Unpacking...

call %wwunpacker% %input%

echo Working...

ren 0001000157505345 rumble_extract

%u8tool% -file %cd%\rumble_extract\00000005.app -extract

move rumble_extract\00000005_app_OUT %cd%

%lzh8dec% %cd%\00000005_app_OUT\script.arc.cx Dec_script.arc.cx

%u8tool% -file %cd%\Dec_script.arc.cx -extract

ren Dec_script_arc_cx_OUT script_extract

goto exitPoint

:exitPoint
pause