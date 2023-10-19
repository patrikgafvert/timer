#/bin/bash

if [ ! -d "raylib" ]; then
	git clone --depth=1 https://github.com/raysan5/raylib.git
	cd raylib
	#cmake . -DGRAPHICS=GRAPHICS_API_OPENGL_21 -DCMAKE_C_FLAGS="-s" -DCMAKE_C_FLAGS_RELEASE="-s" -DBUILD_EXAMPLES="OFF"
	cmake . -DBUILD_EXAMPLES="OFF"
	make
	cp raylib/libraylib.a ../
	cp raylib/include/raylib.h ../
	cd ../
fi
gcc -s -o timer timer.c -I. -L. -lraylib -lm
./timer
