#/bin/bash

if [[ "$(glxinfo | grep 'OpenGL version string' | cut -f4 -d' ')" == "1.1" ]];then OPENGLV=GRAPHICS_API_OPENGL_11; fi 
if [[ "$(glxinfo | grep 'OpenGL version string' | cut -f4 -d' ')" == "2.1" ]];then OPENGLV=GRAPHICS_API_OPENGL_21; fi 
if [[ "$(glxinfo | grep 'OpenGL version string' | cut -f4 -d' ')" == "3.3" ]];then OPENGLV=GRAPHICS_API_OPENGL_33; fi 
if [[ "$(glxinfo | grep 'OpenGL version string' | cut -f4 -d' ')" == "4.3" ]];then OPENGLV=GRAPHICS_API_OPENGL_43; fi 

echo OpenGL Version $OPENGLV

if [[ -d "raylib" ]]; then
	#git clone --depth=1 git@github.com:raysan5/raylib.git
	cd raylib/src
	rm -v *.o
	for file in $(ls *.c);do gcc -I external/glfw/include/ -DPLATFORM_DESKTOP -D$OPENGLV -c $file;done
	ar crs libraylib.a *.o	
	cp libraylib.a ../../
	cp raylib.h ../../
	cd ../../
fi

gcc -s -o timer timer.c -I. -L. -lraylib -lm && ./timer

upx --best ./timer
