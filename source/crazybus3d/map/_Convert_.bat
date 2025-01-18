@echo off
echo Converting CrazyBus 3D map
..\..\..\tools\map\ConvertMap.exe Map.tmx Stamps.tsx map.bin stamps.bin "..\data\palette.bin" objects.bin
..\..\..\tools\map\koscmp.exe stamps.bin "..\data\stamps.kos"
..\..\..\tools\map\koscmp.exe map.bin "..\data\map.kos"
del stamps.bin > nul
del map.bin > nul
del objects.bin > nul