#!/bin/bash

# Copyright (c) 2026 embed-dsp, All Rights Reserved.
# Author: Gudmundur Bogason <gb@embed-dsp.com>


# Strict mode: exit on error, unset variable, or pipeline failure
set -euo pipefail


# Directory of this script.
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

# Repository root.
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Cloned llama.cpp repository.
LLAMA_DIR="${REPO_DIR}/github/llama.cpp"

# Installation directory.
INSTALL_DIR=/opt/llama.cpp

# Directory for symbolic links to installed binaries.
BIN_DIR=/opt/bin

# Binaries to build and install.
FILE_LIST="llama-cli llama-server"
# FILE_LIST="llama-cli llama-server llama-perplexity llama-bench llama-quantize"

# ----------------------------------------
# Build
# ----------------------------------------

# Source the CUDA environment.
# source "${REPO_DIR}/../../nvidia/ed_nvidia_cuda/bin/setenv_fedora_cuda_12.9.sh"
source "${REPO_DIR}/../../nvidia/ed_nvidia_cuda/bin/setenv_fedora_cuda_13.1.sh"

# Clone github repo if it does not exist.
if [ ! -d "$LLAMA_DIR" ]; then
    mkdir -p "$(dirname "$LLAMA_DIR")"
    git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_DIR"
fi

# Enter github repo.
cd "$LLAMA_DIR"

# Fetch the latest tags from github.
git fetch --tags --force

# Check out the latest release tag (llama.cpp tags releases as bNNNN
LATEST_TAG="$(git for-each-ref --sort=-v:refname --count=1 --format='%(refname:short)' 'refs/tags/b*')"
git checkout "$LATEST_TAG"

# Clean old build directory.
if [ -d "build" ]; then
    rm -rf build/*
fi

# Configure.
cmake -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON -DGGML_CUDA_NCCL=ON -DNCCL_INCLUDE_DIR=/opt/nvidia/nccl/include -DNCCL_LIBRARY=/opt/nvidia/nccl/lib/libnccl.so

# Build.
cmake --build build -j "$(nproc)" --target $FILE_LIST

# ----------------------------------------
# Install
# ----------------------------------------

# Create installation directories
CURRENT_USER="$(whoami)"

if [ ! -d "$INSTALL_DIR" ]; then
    sudo mkdir -p "$INSTALL_DIR"
    sudo chown "${CURRENT_USER}:${CURRENT_USER}" "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/bin"
fi

# Copy files and create symbolic links.
for target in $FILE_LIST; do
    cp "${LLAMA_DIR}/build/bin/$target" "$INSTALL_DIR/bin/"
    ln -sf "$INSTALL_DIR/bin/$target" "$BIN_DIR/$target"
done


# ----------------------------------------
# Summary
# ----------------------------------------
echo "llama.cpp ${LATEST_TAG} installed:"
for target in $FILE_LIST; do
    echo "  ${INSTALL_DIR}/bin/$target"
    echo "  ${BIN_DIR}/$target -> ${INSTALL_DIR}/bin/$target"
done
