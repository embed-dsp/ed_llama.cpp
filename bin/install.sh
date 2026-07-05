#!/bin/bash

# Copyright (c) 2026 embed-dsp, All Rights Reserved.
# Author: Gudmundur Bogason <gb@embed-dsp.com>


# ...
INSTALL_DIR=/opt/llama.cpp

# ...
BIN_DIR=/opt/bin

# ...
FILE_LIST="llama-cli llama-mtmd-cli llama-server llama-gguf-split llama-perplexity llama-bench"


# ----------------------------------------
# Create installation directories
# ----------------------------------------
if [ ! -d "$INSTALL_DIR" ]; then
    sudo mkdir -p "$INSTALL_DIR"
    sudo chown gb:gb "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/bin"
fi


# ----------------------------------------
# Copy files
# ----------------------------------------
cp ../github/llama.cpp/build/bin/*  "$INSTALL_DIR/bin/"


# ----------------------------------------
# Create symbolic links
# ----------------------------------------
for target in $FILE_LIST; do
    # Delete existing symbolic link.
    if [ -L "$BIN_DIR/$target" ]; then
        rm "$BIN_DIR/$target"
    fi

    # Create symbolic links.
    ln -s "$INSTALL_DIR/bin/$target" "$BIN_DIR/$target"
done
