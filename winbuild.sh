#/bin/bash

if [[ -d "raylib" ]]; then
	#git clone --depth=1 git@github.com:raysan5/raylib.git
	cd raylib/src
	rm -v *.o
	for file in $(ls *.c);do x86_64-w64-mingw32-gcc -I external/glfw/include/ -DPLATFORM_DESKTOP -c $file;done
	ar crs libraylib.a *.o	
	cp libraylib.a ../../
	cp raylib.h ../../
	cd ../../
fi
x86_64-w64-mingw32-gcc -s -o timer timer.c -I. -L. -lraylib -lgdi32 -lwinmm 
upx timer.exe
