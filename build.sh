#/bin/bash

if [[ ! -d "raylib" ]]; then
	git clone --depth=1 git@github.com:raysan5/raylib.git
	cd raylib
	if [[ "$(glxinfo | grep "OpenGL version" | cut -d' ' -f4)" = "2.1" ]]; then
		cmake . -DGRAPHICS=GRAPHICS_API_OPENGL_21 -DBUILD_EXAMPLES="OFF"
	else
		cmake . -DBUILD_EXAMPLES="OFF"
	fi
	make
	cp raylib/libraylib.a ../
	cp raylib/include/raylib.h ../
	cd ../
fi
gcc -s -o timer timer.c -I. -L. -lraylib -lm
./timer
