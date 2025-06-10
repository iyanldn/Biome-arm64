# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM rust:1.76 as builder

WORKDIR /app
COPY . .

# Siapkan toolchain dan target
RUN rustup target add aarch64-unknown-linux-gnu armv7-unknown-linux-gnueabihf x86_64-unknown-linux-gnu

# Build release untuk target default
RUN cargo build --release

# Stage runtime (lebih kecil, minimal)
FROM debian:bullseye-slim

WORKDIR /app
COPY --from=builder /app/target/release/biome /usr/local/bin/biome

ENTRYPOINT ["biome"]
