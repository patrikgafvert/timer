#/bin/bash

xc_prefix="x86_64-w64-mingw32-"
cc="${xc_prefix}gcc"

echo Compiling with $cc

git pull

if [[ ! -d "raylib" ]]; then
	git clone --depth=1 git@github.com:raysan5/raylib.git
fi

if [[ ! -f "libraylib-win.a" ]]; then
	cd raylib
	git pull
	cd src
	rm -v *.o
	rm -v libraylib.a
	for file in $(ls *.c);do $cc -I /usr/x86_64-w64-mingw32/include/ -I external/glfw/include/ -DPLATFORM_DESKTOP -c $file;done
	${xc_prefix}ar crs libraylib-win.a *.o	
	cd ../../
fi

$cc -s -o timer timer.c -I. -I ./raylib/src -L ./raylib/src  -l raylib-win -l gdi32 -l winmm
upx --best timer.exe
