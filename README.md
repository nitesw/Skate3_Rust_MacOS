<p align="center">
  <img src="docs/images/skating-crab.png" alt="Rust crab riding a skateboard" width="480">
</p>

# Skate 3 Rust Engine (macOS Port)

A Rust and Bevy skating project built from Skate 3 reverse-engineering research, ported to run natively on **macOS (Apple Silicon & Intel)** via Apple Metal and native gamepad support.

Includes skating, tricks, grinds, offboard movement, difficulty settings and `.skate` map support. Gameplay parity is still a work in progress.

> **Note:** This repository is a macOS port fork of the upstream [SK8-ENGINE/skate-3-rust-engine](https://github.com/SK8-ENGINE/skate-3-rust-engine).

---

## Changes in this macOS Port

1. **Apple Metal Rendering**:
   - Switched Bevy's rendering backend from Vulkan (`Backends::VULKAN`) to native Apple Metal (`Backends::METAL` via `wgpu`) on macOS.
   - **Naga Metal Shader Fix**: Naga's Metal backend emits `gradient2d` for cube array `textureSampleGrad`, which the Apple Metal shader compiler rejects. Implemented a workaround (`CUBE_ARRAY_GRAD_AS_LEVEL`) in `retail_material_bindings.wgsl` and `retail_render.rs` using `textureSampleLevel` with calculated level-of-detail (LOD) for cube array environment sampling.

2. **Native Controller Input via `gilrs`**:
   - macOS does not support Windows XInput. Added `gilrs` (IOKit HID) on macOS to poll connected gamepads (PlayStation DualShock/DualSense, Xbox, Switch Pro, MFi, etc.).
   - Controller axes and buttons are repacked directly into the TU3 XInput layout, ensuring identical raw values for authentic Flickit analog stick trick physics and gestures.

3. **macOS Build & Launcher Scripts**:
   - Added `build.sh` for compiling native release binaries with `-C target-cpu=native`.
   - Added `play.sh` to automatically locate converted game assets in `install/installations/*/assets` and launch the game.

---

## macOS Setup & Instructions

### 1. Prerequisites
- **macOS** 12 Monterey or newer (Apple Silicon M-series or Intel x86_64)
- **Rust toolchain** (stable):
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```
- **Python 3** with Tkinter:
  ```bash
  pip3 install -r tools/requirements-setup.txt
  ```
- **Game Controller**: Connect any Xbox, PlayStation DualSense/DualShock, or standard HID gamepad via Bluetooth or USB.
- **Skate 3 Game Files**: Legally dumped Skate 3 Xbox 360 ISO or extracted game folder containing `default.xex`. (Tools like `extract-xiso` can extract Xbox 360 ISOs on macOS).

### 2. Build
Build the release binary natively for your Mac architecture:
```bash
./build.sh
```
Or via cargo:
```bash
RUSTFLAGS="-C target-cpu=native" cargo build --release --bin skate3rust
```

### 3. Asset Setup
Game assets must be extracted and prepared from your legally dumped copy of Skate 3:
```bash
python3 tools/setup.py --base install --game-exe target/release/skate3rust
```
In the setup window, point to your `default.xex` or extracted game directory. The pipeline will automatically unpack and convert:
- Skater models, rigs, and customizable materials
- Core animations and trick stategraphs
- University map and disc environments
- Original HUD font and scoring assets

The converted assets will be saved to `install/installations/<id>/assets`.

### 4. Play
Run the game using the launcher script:
```bash
./play.sh
```
Or launch directly with cargo/executable:
```bash
cargo run --release --bin skate3rust -- --assets install/installations/<id>/assets
```

**Controls**:
- **Right Stick**: Flickit trick controls (ollie, kickflip, laserflip, etc.)
- **Left Stick**: Steering and board control
- **Left / Right Triggers**: Left / Right hand grabs & brake
- **A / X Buttons**: Push (regular / mongo)
- **Y / Triangle**: Get on / off board
- **Escape**: In-game menu (difficulty settings, graphics, map selection)

---

## History

Before this rewrite existed, **dumbad** spent more than two years reverse
engineering Skate 3 and building the tools needed to understand and work with
it. That meant countless hours digging through undocumented file formats,
animation data, and game interaction systems, then testing those discoveries
in the original game. Much of that work is collected in
[DumbadsSkate3ModdingTools](https://github.com/Ethanw05/DumbadsSkate3ModdingTools),
including tools for custom maps, meshes, collision, challenges, and DLC.

That research laid the groundwork for this project. Chasm later worked on a
recompilation and a custom renderer based on dumbad's earlier renderer work,
before moving into the Rust/Bevy rewrite. The rewrite's development time tells
only part of the story: the knowledge and tools it relies on took years of
work to establish.

## AI usage

AI coding tools were used to develop this rewrite, but none of it would have
been possible without dumbad's extraordinary effort to reverse engineer the
original game. The AI had years of hard-earned research and working tools to
build on. Describing the project as simply “AI rewriting Skate 3” leaves out
the work that made it possible in the first place.

AI helped turn that knowledge into a new implementation; it does not replace
credit for discovering how the game works. This is still a work in progress,
and using original assets or showing working tricks does not mean every
system behaves exactly like the original.

## Advanced diagnostics

Both macOS and Windows builds support opt-in [performance timeline capture](docs/performance-tracing.md)
through the `--trace` CLI option, including optional GPU pass diagnostics.

## License & Credits

Copyright (c) 2026 dumbad and the Skate 3 Rust Engine contributors.
Unless otherwise noted, this project's original code is licensed under the
[GNU General Public License version 3 only](LICENSE) (`GPL-3.0-only`).
You may use, modify, and distribute it, including commercially. If you distribute
a modified version or a binary of the covered software, you must also make its
corresponding source available under GPLv3 and preserve the required notices.

Third-party code retains its existing licenses and copyright notices, including
the vendored Bevy crates and tooling under `tools/vendor/`. This license does
not grant rights to Electronic Arts' game code, data, assets, or trademarks,
or to content supplied by other map and mod authors.

Implementation notes are in [`docs/`](docs/). Patched Bevy dependencies and
their licenses are in [`vendor/`](vendor/). This is an unofficial project,
not affiliated with Electronic Arts (EA).
