#/bin/bash
OPENGLV="$(glxinfo | grep 'OpenGL version string' | cut -f4 -d' ' | tr -d '.')"
echo OpenGL Version $OPENGLV

if [[ ! -d "raylib" ]]; then
	git clone --depth=1 git@github.com:raysan5/raylib.git
fi

if [[ ! -f "libraylib.a" ]]; then
	cd raylib/src
	git pull
	rm -v *.o
	rm -v libraylib.a
	for file in $(ls *.c);do gcc -I external/glfw/include/ -DPLATFORM_DESKTOP -DGRAPHICS_API_OPENGL_$OPENGLV -c $file;done
	ar crs libraylib.a *.o	
	cp libraylib.a ../../
	cp raylib.h ../../
	cd ../../
fi

gcc -s -o timer timer.c -I. -L. -lraylib -lm

upx --best ./timer

./timer
