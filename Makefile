all:
	@echo check Makefile contents for what to do
add2recent: add2recent.c
	gcc -std=c99 add2recent.c -o add2recent `pkg-config --cflags gtk+-3.0 --libs`
add2recent-gtk2: add2recent.c
	gcc -std=c99 add2recent.c -o add2recent `pkg-config --cflags gtk+-2.0 --libs`
