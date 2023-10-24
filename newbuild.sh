#/bin/bash

if [[ ! -d "raylib" ]]; then
	git clone --depth=1 git@github.com:raysan5/raylib.git
	cd raylib/src
	make clean
	for file in $(ls *.c);do gcc -I raylib/src/external/glfw/include -DPLATFORM_DESKTOP -c $file;done
	ar crs libraylib.a *.o	
	cp libraylib.a ../../
	cp raylib.h ../../
	cd ../../
fi
gcc -s -o timer timer.c -I. -L. -lraylib -lm && ./timer
