
# Build and Installation of llama.cpp

This repository contains bash scripts for the build and installation of the 
[llama.cpp](https://github.com/ggml-org/llama.cpp) LLM inference engine on **Linux**.


## Overview

The `bin` directory contains the following bash scripts:

```text
bin/
├── build.sh        # Build llama.cpp LLM inference engine.
└── install.sh      # Install llama.cpp LLM inference engine in the local file system.
```

**NOTE**: The `llama.cpp` LLM inference engine requires that the **NVIDIA CUDA Toolkit** and **NVIDIA NCCL** are installed on the system.
Instructions for installing the **NVIDIA CUDA Toolkit** can be found here [ed_nvidia_cuda](https://github.com/embed-dsp/ed_nvidia_cuda)
and instructions for build and installation of **NVIDIA NCCL** can be found here [ed_nvidia_nccl](https://github.com/embed-dsp/ed_nvidia_nccl)


## Build

Enter the `bin` directory and edit the `build.sh` script.
Make sure that the path to the sourcing of the CUDA environment is set correctly.
Also, make sure that the paths to NCCL are set correctly in the `cmake` configuration.

Type the following command:

```sh
./build.sh
```


## Local Installation

Enter the `bin` directory and edit the `install.sh` script.
Make sure that the `owner:group` is set correctly for the `chown` command.

Type the following command:

```sh
./install.sh
```

The `llama.cpp` LLM inference engine is installed in the local file system in `/opt/llama.cpp`:

```text
/opt/llama.cpp
└── bin
    ├── llama-bench
    ├── llama-cli
    ├── llama-gguf-split
    ├── llama-mtmd-cli
    ├── llama-perplexity
    └── llama-server
```

Symbolic links are created from `/opt/bin` to the respective executables in `/opt/llama.cpp/bin`

```text
/opt/bin
    llama-bench -> /opt/llama.cpp/bin/llama-bench
    llama-cli -> /opt/llama.cpp/bin/llama-cli
    llama-gguf-split -> /opt/llama.cpp/bin/llama-gguf-split
    llama-mtmd-cli -> /opt/llama.cpp/bin/llama-mtmd-cli
    llama-perplexity -> /opt/llama.cpp/bin/llama-perplexity
    llama-server -> /opt/llama.cpp/bin/llama-server
```


## Links

* https://github.com/ggml-org/llama.cpp
* https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md
