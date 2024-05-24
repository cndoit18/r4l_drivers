# syntax=docker/dockerfile:1

# Stage 1 Build QEMU
# - https://www.qemu.org/download/
# - https://wiki.qemu.org/Hosts/Linux#Building_QEMU_for_Linux
# - https://wiki.qemu.org/Documentation/Platforms/RISCV

FROM ubuntu:20.04 as build_qemu

ARG QEMU_VERSION=9.0.0

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \ 
    sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \ 
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
    gawk build-essential bison flex texinfo gperf libtool patchutils bc \
    zlib1g-dev libexpat-dev pkg-config libglib2.0-dev libpixman-1-dev libsdl2-dev \
    git tmux python3 python3-pip ninja-build wget

RUN wget https://download.qemu.org/qemu-${QEMU_VERSION}.tar.xz && \
    tar xf qemu-${QEMU_VERSION}.tar.xz && \
    cd qemu-${QEMU_VERSION} && \ 
    ./configure --target-list=aarch64-softmmu,arm-softmmu && \
    make -j$(nproc) && \
    make install

# Stage 2 Set Lab Environment
FROM ubuntu:20.04 as build

WORKDIR /tmp

# 2.0. Copy qemu
COPY --from=build_qemu /usr/local/bin/* /usr/local/bin

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \ 
    sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \ 
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y jq curl git python3 wget build-essential tmux lsb-release software-properties-common && \
    curl -sfL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs)-17 main" && \
    apt-get update && \
    apt-get install -y libelf-dev libgmp-dev libmpc-dev bc flex \
    bison u-boot-tools llvm-17 lld-17 clang-17 aptitude libssl-dev libpixman-1-dev libsdl2-2.0-0

# 2.1. Install Rust
# - https://www.rust-lang.org/tools/install
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static \
    RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --no-modify-path

# 2.2. Sanity checking
RUN rustup --version && \
    cargo --version && \
    rustc --version

# 2.3 Env
RUN cargo install cargo-binutils; \
    rustup target add riscv64gc-unknown-none-elf; \
	rustup component add rust-src; \
	rustup component add llvm-tools-preview; \
	rustup component add rustfmt; \
	rustup component add clippy;

