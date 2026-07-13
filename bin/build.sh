#!/bin/bash

# Copyright (c) 2026 embed-dsp, All Rights Reserved.
# Author: Gudmundur Bogason <gb@embed-dsp.com>


# Source the CUDA environment.
# source ../../../nvidia/ed_nvidia_cuda/bin/setenv_fedora_cuda_12.9.sh
source ../../../nvidia/ed_nvidia_cuda/bin/setenv_fedora_cuda_13.1.sh

# Clone github repo if it does not exist.
if [ ! -d "../github/llama.cpp" ]; then
    mkdir -p ../github
    git clone https://github.com/ggml-org/llama.cpp.git ../github/llama.cpp
fi

# Enter github repo.
cd ../github/llama.cpp

# Fetch and Merge the latest updates from github.
git fetch
git merge

# Clean old build directory.
if [ -d "build" ]; then
    rm -rf build/*
fi

# Configure.
cmake -B build -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON -DGGML_CUDA_NCCL=ON -DNCCL_INCLUDE_DIR=/opt/nvidia/nccl/include -DNCCL_LIBRARY=/opt/nvidia/nccl/lib/libnccl.so

# Build.
cmake --build build --config Release -j 8 --clean-first --target llama-cli llama-mtmd-cli llama-server llama-gguf-split llama-perplexity llama-bench
