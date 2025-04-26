@echo off
echo Converting CrazyBus 3D map
..\..\..\bin\map\ConvertMap.exe Map.tmx Stamps.tsx map.bin stamps.bin "..\data\palette.bin" objects.bin
..\..\..\bin\map\koscmp.exe stamps.bin "..\data\stamps.kos"
..\..\..\bin\map\koscmp.exe map.bin "..\data\map.kos"
del stamps.bin > nul
del map.bin > nul
del objects.bin > nul