
#ifdef _linux
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "font.h"
#include "raylib.h"
#include <linux/uinput.h>
#elif defined _WIN32
#include "font.h"
#include "raylib.h"
#include <stddef.h>
#endif

#ifdef _linux
void emit(int fd, int type, int code, int val) {
  struct input_event ie;
  ie.type = type;
  ie.code = code;
  ie.value = val;
  ie.time.tv_sec = 0;
  ie.time.tv_usec = 0;
  write(fd, &ie, sizeof(ie));
}

void sendkey_nextsong(int fd) {
  emit(fd, EV_KEY, KEY_NEXTSONG, 1);
  emit(fd, EV_SYN, SYN_REPORT, 0);
  emit(fd, EV_KEY, KEY_NEXTSONG, 0);
  emit(fd, EV_SYN, SYN_REPORT, 0);
}

void sendkey_right(int fd) {
  emit(fd, EV_KEY, KEY_RIGHT, 1);
  emit(fd, EV_SYN, SYN_REPORT, 0);
  emit(fd, EV_KEY, KEY_RIGHT, 0);
  emit(fd, EV_SYN, SYN_REPORT, 0);
}
#endif

struct TimerWindow {
  int x;
  int y;
  int height;
  int width;
  int fontsize;
  int leftborder;
  int topborder;
  int rightborder;
  int bottonborder;
  int textshadow;
  int shadowtextposx;
  int shadowtextposy;
};

int main(int argc, char *argv[]) {

  struct TimerWindow timerwindow = {
      .x = 0,
      .y = 0,
      .height = 100,
      .width = 100,
      .fontsize = 100,
      .leftborder = 30,
      .topborder = 30,
      .rightborder = 30,
      .bottonborder = 30,
      .textshadow = 20,
      .shadowtextposx = 0,
      .shadowtextposy = 0};

  int i = 1;
  int j = 19;
  int sizeout;

#ifdef _linux
  FILE *fp;
  struct uinput_setup usetup;
  int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
  memset(&usetup, 0, sizeof(usetup));
  usetup.id.bustype = BUS_USB;
  usetup.id.vendor = 0x1234;  /* sample vendor */
  usetup.id.product = 0x5678; /* sample product */
  strcpy(usetup.name, "Example device");
  ioctl(fd, UI_SET_EVBIT, EV_KEY);
  ioctl(fd, UI_SET_KEYBIT, KEY_RIGHT);
  ioctl(fd, UI_SET_KEYBIT, KEY_NEXTSONG);
  ioctl(fd, UI_DEV_SETUP, &usetup);
  ioctl(fd, UI_DEV_CREATE);
  sleep(1);
#endif

  int textw;
  char text[80];

  SetTraceLogLevel(LOG_ERROR);
  SetTargetFPS(60);
  char *out;
  out = DecompressData(font, 0, &sizeout);

  InitWindow(timerwindow.width, timerwindow.height, "Timer");
  SetWindowPosition(timerwindow.x, timerwindow.y);
  SetWindowState(FLAG_WINDOW_TOPMOST | FLAG_WINDOW_RESIZABLE);
  Font fontTtf = LoadFontFromMemory(".ttf", out, sizeout, timerwindow.height, NULL, 0);
  textw = MeasureTextEx(fontTtf, TextFormat("%02d-%02d", i, j), (float)timerwindow.fontsize, 0).x;

  timerwindow.height = timerwindow.height + timerwindow.topborder + timerwindow.bottonborder;
  timerwindow.width = timerwindow.leftborder + textw + timerwindow.rightborder;

  float timerMaxValue = 1;
  float timerCurrentValue = timerMaxValue;

  bool pause = false;
  bool exit = false;

  SetWindowSize(timerwindow.width, timerwindow.height);

  while (!exit) {
    if (IsKeyPressed(KEY_ESCAPE) || WindowShouldClose())
      exit = true;
    if (IsKeyPressed(32))
      pause = !pause;
    timerCurrentValue -= GetFrameTime();
    if (timerCurrentValue < 0 | pause) {
      if (pause) {
        timerCurrentValue = timerMaxValue;
      } else {
        j--;
        timerCurrentValue = timerMaxValue;
      }
    }

    if (j < 0) {
      i++;
      j = 19;
#ifdef _linux
      sendkey_right(fd);
      sendkey_nextsong(fd);
#endif
    }

    if (i > 20)
      exit = true;

    timerwindow.height = GetRenderHeight();
    timerwindow.width = GetRenderWidth();
    timerwindow.shadowtextposx = timerwindow.rightborder + timerwindow.textshadow;
    timerwindow.shadowtextposy = timerwindow.topborder + timerwindow.textshadow;

    BeginDrawing();
    ClearBackground((Color){30, 30, 30, 0});
    DrawTextEx(fontTtf, TextFormat("%02d-%02d", i, j), (Vector2){(float)timerwindow.shadowtextposx, (float)timerwindow.shadowtextposy}, (float)timerwindow.height - timerwindow.topborder - timerwindow.bottonborder, 0, BLACK);
    DrawTextEx(fontTtf, TextFormat("%02d-%02d", i, j), (Vector2){(float)timerwindow.rightborder, (float)timerwindow.topborder}, (float)timerwindow.height - timerwindow.topborder - timerwindow.bottonborder, 0, GREEN);
    EndDrawing();
  }

  UnloadFont(fontTtf);
  CloseWindow();
  return 0;

#ifdef _linux
  ioctl(fd, UI_DEV_DESTROY);
  close(fd);
#endif
}
