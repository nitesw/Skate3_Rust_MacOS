#!/bin/sh
# Build skate3rust for macOS with native CPU optimizations.
set -e
cd "$(dirname "$0")"

export RUSTFLAGS="-C target-cpu=native"
cargo build --release --bin skate3rust
