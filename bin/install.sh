#!/bin/bash

# Copyright (c) 2026 embed-dsp, All Rights Reserved.
# Author: Gudmundur Bogason <gb@embed-dsp.com>


# ...
set -euo pipefail


# ...
INSTALL_DIR=/opt/llama.cpp

# ...
BIN_DIR=/opt/bin

# ...
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

# ...
FILE_LIST="llama-cli llama-server llama-perplexity llama-bench llama-quantize"


# ----------------------------------------
# Create installation directories
# ----------------------------------------
CURRENT_USER="$(whoami)"

if [ ! -d "$INSTALL_DIR" ]; then
    sudo mkdir -p "$INSTALL_DIR"
    sudo chown "${CURRENT_USER}:${CURRENT_USER}" "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/bin"
fi


# ----------------------------------------
# Copy files
# ----------------------------------------
cp ${SCRIPT_DIR}/../github/llama.cpp/build/bin/*  "$INSTALL_DIR/bin/"


# ----------------------------------------
# Create symbolic links
# ----------------------------------------
for target in $FILE_LIST; do
    ln -sf "$INSTALL_DIR/bin/$target" "$BIN_DIR/$target"
done
