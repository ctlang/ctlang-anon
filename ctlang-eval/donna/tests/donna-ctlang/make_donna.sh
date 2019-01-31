#!/bin/bash
set -e

DONNA=$PWD
OBJ_DIR=../..

# copy CTLang port
cp $OBJ_DIR/obj/curve25519-c64.O2.o $DONNA/curve25519-donna-ctlang64.o

# (re)compile with ctlang stubbed in
make test -j4
make speed -j4
