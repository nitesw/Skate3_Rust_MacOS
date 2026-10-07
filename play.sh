#!/bin/sh
# Build (if needed) and launch the game with the converted macOS assets.
# Extra arguments are passed through to the game.
set -e
cd "$(dirname "$0")"

assets=$(ls -dt install/installations/*/assets 2>/dev/null | head -n 1)
if [ -z "$assets" ]; then
    echo "No converted assets found in install/installations. Run asset setup first." >&2
    exit 1
fi

export RUSTFLAGS="-C target-cpu=native"
export VULKAN_SDK=""
exec cargo run --release --bin skate3rust -- --assets "$assets" "$@"
