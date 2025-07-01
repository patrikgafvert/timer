#/bin/bash
OPENGLV="$(glxinfo | grep 'OpenGL version string' | cut -f4 -d' ' | tr -d '.')"
echo OpenGL Version $OPENGLV

git pull

if [[ ! -d "raylib" ]]; then
	git clone --depth=1 git@github.com:raysan5/raylib.git
fi

if [[ ! -f "libraylib.a" ]]; then
	cd raylib
	git pull
	cd src
	rm -v *.o
	rm -v libraylib.a
	for file in $(ls *.c);do gcc -I . -I external/glfw/include -DPLATFORM_DESKTOP_GLFW -DGRAPHICS_API_OPENGL_$OPENGLV -D_GLFW_X11 -Wall -Wextra -c $file;done
	ar crs libraylib.a *.o	
	cd ../../
fi

gcc -s -o timer timer.c -I. -I ./raylib/src -L raylib/src -l raylib -l m -Wall -Wextra

upx --best ./timer

./timer
