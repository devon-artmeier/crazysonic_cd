@echo off

set ASM68K=tools\asm68k.exe /p /o ae-,l.,m+,op+,os+,ow+,oz+,oaq+,osq+,omq+ /e REGION='%REGION%'

if not exist build mkdir build > nul
if not exist build\files mkdir build\files > nul
if not exist build\system mkdir build\system > nul
del /F /Q build\files\*.* > nul
del /F /Q build\system\*.* > nul

cd src\special\map
call _Convert_.bat
cd ..\..\..

cd src\crazybus3d\map
call _Convert_.bat
cd ..\..\..

%ASM68K% src\main.asm,build\files\MAIN.M68,src\main.sym,src\main.lst
tools\get-psyq-symbols.exe src\main.sym src\include\main_program.inc
if exist src\main.sym del src\main.sym > nul

%ASM68K% src\system\main\boot.asm,build\system\boot.bin,,src\system\main\boot.lst
%ASM68K% src\system\sub\core.asm,build\system\system.bin,src\system\sub\core.sym,src\system\sub\core.lst
tools\get-psyq-symbols.exe src\system\sub\core.sym src\include\sub_program.inc
if exist src\system\sub\core.sym del src\system\sub\core.sym > nul

%ASM68K% src\sound\crazybus_pcm.asm,build\files\CBPCM.S68,src\sound\crazybus_pcm.sym,src\sound\crazybus_pcm.lst
tools\get-psyq-symbols.exe src\sound\crazybus_pcm.sym src\sound\crazybus_pcm.inc
if exist src\sound\crazybus_pcm.sym del src\sound\crazybus_pcm.sym > nul

%ASM68K% src\title\title.asm,build\files\TITLE.M68,,src\title\title.lst

%ASM68K% src\sonic\Level GHZ.asm,build\files\GHZ.M68,,src\sonic\Level GHZ.lst
%ASM68K% src\sonic\Level MZ.asm,build\files\MZ.M68,,src\sonic\Level MZ.lst
%ASM68K% src\sonic\Level SYZ.asm,build\files\SYZ.M68,,src\sonic\Level SYZ.lst
%ASM68K% src\sonic\Level LZ.asm,build\files\LZ.M68,,src\sonic\Level LZ.lst
%ASM68K% src\sonic\Level SLZ.asm,build\files\SLZ.M68,,src\sonic\Level SLZ.lst
%ASM68K% src\sonic\Level SBZ.asm,build\files\SBZ.M68,,src\sonic\Level SBZ.lst
%ASM68K% src\sonic\Level Secret.asm,build\files\SECRET.M68,,src\sonic\Level Secret.lst
%ASM68K% src\sonic\Ending.asm,build\files\END.M68,,src\sonic\Ending.lst

%ASM68K% src\special\data.asm,build\files\SPECDATA.DAT,src\special\data.sym,src\special\data.lst
tools\get-psyq-symbols.exe src\special\data.sym src\special\data_labels.inc
if exist src\special\data.sym del src\special\data.sym > nul
%ASM68K% src\special\main.asm,build\files\SPECMAIN.M68,,src\special\main.lst
%ASM68K% src\special\sub.asm,build\files\SPECSUB.S68,,src\special\sub.lst

%ASM68K% src\crazybus3d\data.asm,build\files\BUS3DDATA.DAT,src\crazybus3d\data.sym,src\crazybus3d\data.lst
tools\get-psyq-symbols.exe src\crazybus3d\data.sym src\crazybus3d\data_labels.inc
if exist src\crazybus3d\data.sym del src\crazybus3d\data.sym > nul
%ASM68K% src\crazybus3d\main.asm,build\files\BUS3DMAIN.M68,,src\crazybus3d\main.lst
%ASM68K% src\crazybus3d\sub.asm,build\files\BUS3DSUB.S68,,src\crazybus3d\sub.lst

%ASM68K% src\hk97\data.asm,build\files\HK97DATA.DAT,src\hk97\data.sym,src\hk97\data.lst
tools\get-psyq-symbols.exe src\hk97\data.sym src\hk97\data_labels.inc
if exist src\hk97\data.sym del src\hk97\data.sym > nul
%ASM68K% src\hk97\main.asm,build\files\HK97MAIN.M68,,src\hk97\main.lst
%ASM68K% src\hk97\sub.asm,build\files\HK97SUB.S68,,src\hk97\sub.lst

%ASM68K% src\meme\main.asm,build\files\MEME.M68,,src\meme\main.lst

echo.
tools\build-crazysonic-disc.exe -volname CRAZYSONIC -volver 1.0 -sysname CRAZYSONIC -sysver 1.0 -copy RALA -title "CrazySonic CD" -serial 69420666 -revision 69 -io J -region %REGION% -ip build\system\boot.bin -sp build\system\system.bin -dir build\files -o build\%OUTPUT%

certutil -hashfile build\%OUTPUT% MD5
pause