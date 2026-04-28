FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Build + runtime dependencies
RUN apt update && apt install -y --no-install-recommends \
    # Build deps
    meson ninja-build gcc make git patch pkg-config \
    libarchive-dev libssl-dev libgpgme-dev libcurl4-openssl-dev \
    # Runtime deps
    ca-certificates wine \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /proc/self/mounts /etc/mtab

WORKDIR /build
COPY . .

RUN make && make PREFIX=/usr install

# Initialize ucrt64 environment
RUN linsys2-pacman -Syu --noconfirm
RUN linsys2-pacman -Sy --noconfirm \
    mingw-w64-ucrt-x86_64-gcc

RUN linsys2 run -- gcc --version
