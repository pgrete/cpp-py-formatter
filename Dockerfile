# Build the GitHub Action
FROM rust:1.87.0 as builder
WORKDIR /usr/src/myapp
COPY Cargo.toml .
COPY Cargo.lock .
COPY src ./src
RUN cargo install --path .

# GitHub Action Image
FROM ubuntu:24.04
# Install our apt packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends git \
  python3-pip \
  clang-format-14 \
  clang-format-15 \
  clang-format-16 \
  clang-format-17 \
  clang-format-18 \
  clang-format-19 \
  clang-format-20 \
  && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install --break-system-packages black

COPY gitconfig /etc

COPY --from=builder /usr/local/cargo/bin/cpp-py-format /cpp-py-format
ENTRYPOINT [ "/cpp-py-format" ]
