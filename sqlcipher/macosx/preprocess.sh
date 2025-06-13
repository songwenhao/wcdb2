#!/bin/bash

root=`git rev-parse --show-toplevel`

cd "$root"

files=(opcodes.h opcodes.c keywordhash.h fts5.c fts5.h sqlite3.h parse.h parse.c config.h)

for file in ${files[@]};
do
    rm $file
done

./configure CFLAGS="-DSQLITE_ENABLE_UPDATE_DELETE_LIMIT" --with-crypto-lib=commoncrypto --enable-update-limit --disable-amalgamation --enable-fts3 --enable-fts4 --enable-fts5 --enable-cross-thread-connections

make clean

for file in ${files[@]};
do
    make $file
done
