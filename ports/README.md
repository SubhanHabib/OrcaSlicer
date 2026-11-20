# Platework engine targets

The `platework` branch descends from official OrcaSlicer v2.5.1. Desktop builds continue to use the upstream project. The Apple build wraps libslic3r with the C++ session in `src/mobile/core`. Its Bambu archive exporter obtains the model ID from the selected vendor preset. The browser target links libslic3r through the one-slicer-api bindings in `ports/wasm`.

On macOS with Xcode, Ninja, CMake, automake, libtool and texinfo installed, `scripts/build_ios_core.sh -a all -x` builds a device and simulator XCFramework. The Linux Emscripten build runs `ports/wasm/scripts/build-local-wsl.sh` with the SDK and dependencies shown in the Platework WASM workflow. Both CI builds upload artifacts against the Git commit that supplied their sources. The Platework apps pin that commit as their Engine submodule.

The Apple session and build machinery derive from [the Orca mobile port](https://github.com/angelo-hub/orcaslicer/tree/abba85deb95ec035dc2d3e5d51a539598f51597b). The WASM bindings and build machinery derive from [OrcaWasm](https://github.com/Hiosdra/OrcaWasm/tree/60a09e04f1990be39c8f6f35dffef1a2c9e224c4). See the root license and the notices in `ports/wasm`.
