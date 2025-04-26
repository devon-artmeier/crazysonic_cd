@echo off

set ASM68K=bin\asm68k.exe /p /o ae-,l.,m+,op+,os+,ow+,oz+,oaq+,osq+,omq+ /e REGION='%REGION%'

if not exist out mkdir out > nul
if not exist out\files mkdir out\files > nul
if not exist out\system mkdir out\system > nul
del /F /Q out\files\*.* > nul
del /F /Q out\system\*.* > nul

cd src\special\map
call _Convert_.bat
cd ..\..\..

cd src\crazybus3d\map
call _Convert_.bat
cd ..\..\..

%ASM68K% src\main.asm,out\files\MAIN.M68,src\main.sym,src\main.lst
bin\get_psyq_symbols.exe src\main.sym src\include\main_program.inc
if exist src\main.sym del src\main.sym > nul

%ASM68K% src\system\main\boot.asm,out\system\boot.bin,,src\system\main\boot.lst
%ASM68K% src\system\sub\core.asm,out\system\system.bin,src\system\sub\core.sym,src\system\sub\core.lst
bin\get_psyq_symbols.exe src\system\sub\core.sym src\include\sub_program.inc
if exist src\system\sub\core.sym del src\system\sub\core.sym > nul

%ASM68K% src\sound\crazybus_pcm.asm,out\files\CBPCM.S68,src\sound\crazybus_pcm.sym,src\sound\crazybus_pcm.lst
bin\get_psyq_symbols.exe src\sound\crazybus_pcm.sym src\sound\crazybus_pcm.inc
if exist src\sound\crazybus_pcm.sym del src\sound\crazybus_pcm.sym > nul

%ASM68K% src\title\title.asm,out\files\TITLE.M68,,src\title\title.lst

%ASM68K% src\sonic\Level GHZ.asm,out\files\GHZ.M68,,src\sonic\Level GHZ.lst
%ASM68K% src\sonic\Level MZ.asm,out\files\MZ.M68,,src\sonic\Level MZ.lst
%ASM68K% src\sonic\Level SYZ.asm,out\files\SYZ.M68,,src\sonic\Level SYZ.lst
%ASM68K% src\sonic\Level LZ.asm,out\files\LZ.M68,,src\sonic\Level LZ.lst
%ASM68K% src\sonic\Level SLZ.asm,out\files\SLZ.M68,,src\sonic\Level SLZ.lst
%ASM68K% src\sonic\Level SBZ.asm,out\files\SBZ.M68,,src\sonic\Level SBZ.lst
%ASM68K% src\sonic\Level Secret.asm,out\files\SECRET.M68,,src\sonic\Level Secret.lst
%ASM68K% src\sonic\Ending.asm,out\files\END.M68,,src\sonic\Ending.lst

%ASM68K% src\special\data.asm,out\files\SPECDATA.DAT,src\special\data.sym,src\special\data.lst
bin\get_psyq_symbols.exe src\special\data.sym src\special\data_labels.inc
if exist src\special\data.sym del src\special\data.sym > nul
%ASM68K% src\special\main.asm,out\files\SPECMAIN.M68,,src\special\main.lst
%ASM68K% src\special\sub.asm,out\files\SPECSUB.S68,,src\special\sub.lst

%ASM68K% src\crazybus3d\data.asm,out\files\BUS3DDATA.DAT,src\crazybus3d\data.sym,src\crazybus3d\data.lst
bin\get_psyq_symbols.exe src\crazybus3d\data.sym src\crazybus3d\data_labels.inc
if exist src\crazybus3d\data.sym del src\crazybus3d\data.sym > nul
%ASM68K% src\crazybus3d\main.asm,out\files\BUS3DMAIN.M68,,src\crazybus3d\main.lst
%ASM68K% src\crazybus3d\sub.asm,out\files\BUS3DSUB.S68,,src\crazybus3d\sub.lst

%ASM68K% src\hk97\data.asm,out\files\HK97DATA.DAT,src\hk97\data.sym,src\hk97\data.lst
bin\get_psyq_symbols.exe src\hk97\data.sym src\hk97\data_labels.inc
if exist src\hk97\data.sym del src\hk97\data.sym > nul
%ASM68K% src\hk97\main.asm,out\files\HK97MAIN.M68,,src\hk97\main.lst
%ASM68K% src\hk97\sub.asm,out\files\HK97SUB.S68,,src\hk97\sub.lst

%ASM68K% src\meme\main.asm,out\files\MEME.M68,,src\meme\main.lst

echo.
bin\build_crazysonic_disc.exe -volname CRAZYSONIC -volver 1.0 -sysname CRAZYSONIC -sysver 1.0 -copy RALA -title "CrazySonic CD" -serial 69420666 -revision 69 -io J -region %REGION% -ip out\system\boot.bin -sp out\system\system.bin -dir out\files -o out\%OUTPUT%

certutil -hashfile out\%OUTPUT% MD5
pause