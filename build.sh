#!/bin/sh

BUILD_DIR="src/*.d"

rm -rf bin/*

dmd -m64 -I/Users/ondra/Projects/GtkD-1/src $BUILD_DIR -L-L/Users/ondra/Projects/GtkD-1/ /Users/ondra/Projects/GtkD-1/libgtkd-1.a -odbin -ofbin/Pomodoro

bin/Pomodoro

