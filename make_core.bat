@echo off

set REGION=USA
set OUTPUT=MCD_U.iso

set ASM68K=tools\asm68k.exe /p /o ae-,l.,m+,op+,os+,ow+,oz+,oaq+,osq+,omq+ /e REGION='%REGION%'

if not exist build mkdir build > nul
if not exist build\files mkdir build\files > nul
if not exist build\system mkdir build\system > nul
del /F /Q build\files\*.* > nul
del /F /Q build\system\*.* > nul

cd source\special\map
call _Convert_.bat
cd ..\..\..

cd source\crazybus3d\map
call _Convert_.bat
cd ..\..\..

%ASM68K% source\main.asm,build\files\MAIN.M68,source\main.sym,source\main.lst
tools\get-psyq-symbols.exe source\main.sym source\include\main_program.inc
if exist source\main.sym del source\main.sym > nul

%ASM68K% source\system\main\boot.asm,build\system\boot.bin,,source\system\main\boot.lst
%ASM68K% source\system\sub\core.asm,build\system\system.bin,source\system\sub\core.sym,source\system\sub\core.lst
tools\get-psyq-symbols.exe source\system\sub\core.sym source\include\sub_program.inc
if exist source\system\sub\core.sym del source\system\sub\core.sym > nul

%ASM68K% source\sound\crazybus_pcm.asm,build\files\CBPCM.S68,source\sound\crazybus_pcm.sym,source\sound\crazybus_pcm.lst
tools\get-psyq-symbols.exe source\sound\crazybus_pcm.sym source\sound\crazybus_pcm.inc
if exist source\sound\crazybus_pcm.sym del source\sound\crazybus_pcm.sym > nul

%ASM68K% source\title\title.asm,build\files\TITLE.M68,,source\title\title.lst

%ASM68K% source\sonic\Level GHZ.asm,build\files\GHZ.M68,,source\sonic\Level GHZ.lst
%ASM68K% source\sonic\Level MZ.asm,build\files\MZ.M68,,source\sonic\Level MZ.lst
%ASM68K% source\sonic\Level SYZ.asm,build\files\SYZ.M68,,source\sonic\Level SYZ.lst
%ASM68K% source\sonic\Level LZ.asm,build\files\LZ.M68,,source\sonic\Level LZ.lst
%ASM68K% source\sonic\Level SLZ.asm,build\files\SLZ.M68,,source\sonic\Level SLZ.lst
%ASM68K% source\sonic\Level SBZ.asm,build\files\SBZ.M68,,source\sonic\Level SBZ.lst
%ASM68K% source\sonic\Level Secret.asm,build\files\SECRET.M68,,source\sonic\Level Secret.lst
%ASM68K% source\sonic\Ending.asm,build\files\END.M68,,source\sonic\Ending.lst

%ASM68K% source\special\data.asm,build\files\SPECDATA.DAT,source\special\data.sym,source\special\data.lst
tools\get-psyq-symbols.exe source\special\data.sym source\special\data_labels.inc
if exist source\special\data.sym del source\special\data.sym > nul
%ASM68K% source\special\main.asm,build\files\SPECMAIN.M68,,source\special\main.lst
%ASM68K% source\special\sub.asm,build\files\SPECSUB.S68,,source\special\sub.lst

%ASM68K% source\crazybus3d\data.asm,build\files\BUS3DDATA.DAT,source\crazybus3d\data.sym,source\crazybus3d\data.lst
tools\get-psyq-symbols.exe source\crazybus3d\data.sym source\crazybus3d\data_labels.inc
if exist source\crazybus3d\data.sym del source\crazybus3d\data.sym > nul
%ASM68K% source\crazybus3d\main.asm,build\files\BUS3DMAIN.M68,,source\crazybus3d\main.lst
%ASM68K% source\crazybus3d\sub.asm,build\files\BUS3DSUB.S68,,source\crazybus3d\sub.lst

%ASM68K% source\hk97\data.asm,build\files\HK97DATA.DAT,source\hk97\data.sym,source\hk97\data.lst
tools\get-psyq-symbols.exe source\hk97\data.sym source\hk97\data_labels.inc
if exist source\hk97\data.sym del source\hk97\data.sym > nul
%ASM68K% source\hk97\main.asm,build\files\HK97MAIN.M68,,source\hk97\main.lst
%ASM68K% source\hk97\sub.asm,build\files\HK97SUB.S68,,source\hk97\sub.lst

%ASM68K% source\meme\main.asm,build\files\MEME.M68,,source\meme\main.lst

echo.
tools\build-crazysonic-disc.exe -volname CRAZYSONIC -volver 1.0 -sysname CRAZYSONIC -sysver 1.0 -copy RALA -title "CrazySonic CD" -serial 69420666 -revision 69 -io J -region %REGION% -ip build\system\boot.bin -sp build\system\system.bin -dir build\files -o build\%OUTPUT%

certutil -hashfile build\%OUTPUT% MD5
pause