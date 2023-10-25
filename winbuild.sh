#/bin/bash

if [[ ! -d "raylib" ]]; then
	git clone --depth=1 git@github.com:raysan5/raylib.git
fi

if [[ ! -f "libwinraylib.a" ]]; then
	cd raylib/src
	git pull
	rm -v *.o
	rm -v libraylib.a
	for file in $(ls *.c);do x86_64-w64-mingw32-gcc -I external/glfw/include/ -DPLATFORM_DESKTOP -c $file;done
	ar crs libraylib.a *.o	
	cp libraylib.a ../../libwinraylib.a
	cp raylib.h ../../
	cd ../../
fi

x86_64-w64-mingw32-gcc -s -o timer timer.c -I. -L. -lwinraylib -lgdi32 -lwinmm 
upx timer.exe
