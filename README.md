DASH Shell Windows Native (MSVC) builds
=======================================

[![License](https://img.shields.io/badge/license-CC0%20OR%20Apache--2.0%20OR%20MIT-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Build and Release DASH Windows](https://github.com/SamuelMarks/dash-windows/actions/workflows/release.yml/badge.svg)](https://github.com/SamuelMarks/dash-windows/actions/workflows/release.yml)

This repository provides **native Windows builds** of [DASH](http://gondor.apana.org.au/~herbert/dash/)—the Debian Almquist Shell—compiled with Microsoft Visual C++ (MSVC) and CMake.

DASH is a lightweight, POSIX-compliant `/bin/sh` implementation known for its speed and minimal memory footprint. Historically, running DASH on Windows required virtualization (WSL2), heavy runtime emulation environments (Cygwin/MSYS2 DLLs), or complex unmaintained forks.

This project's mission is to provide true native Windows binaries (`dash.exe`) that compile cleanly under MSVC without requiring runtime DLL emulators.

---

## The Magic: `auto-win-msvc`

All POSIX system calls, process spawning, file descriptors, terminal handling, and signals are backed directly by the modular **[auto-win-msvc](https://github.com/SamuelMarks/auto-win-msvc)** compatibility layer.

By decoupling the Windows compatibility layer from the shell implementation itself, we ensure:
- **Pristine Maintainability:** Minimal invasive changes to upstream C code. All POSIX headers map directly to native Win32 APIs.
- **High Performance:** Lightweight, native Windows execution with fast startup and low overhead.
- **Zero Namespace Pollution:** Clean separation without `<windows.h>` namespace pollution or binary bloat.

---

## Key Features

- **Pure CMake Build Harness:** Standalone CMake configuration supporting MSVC 2005, 2019, 2022, 2026, MinGW, Clang, and GCC across Windows, macOS, and Linux.
- **Native Host Generators:** Automatic build-time generation of token tables, AST nodes, syntax lookup tables, builtins, and signal tables.
- **Multiple Packaging Formats:** Generates NSIS executable installers and standalone portable ZIP archives via CPack.
- **Automated CI/CD:** Continuous synchronization and release generation via GitHub Actions.

---

## Releases

Pre-compiled packages are available on the [Releases](../../releases) tab.

### Included Packages:
- **NSIS Setup Installer (`DASH-*-win64.exe`):** Windows installer with option to add DASH to the system PATH.
- **Portable ZIP Archive (`DASH-*-win64.zip`):** Standalone archive containing `dash.exe` and documentation.

---

## Building Locally

To build DASH for Windows from source using Visual Studio / MSVC:

1. Clone `dash`, `auto-win-msvc`, and `dash-windows` side-by-side:
   ```cmd
   git clone https://github.com/SamuelMarks/dash.git
   git clone https://github.com/SamuelMarks/auto-win-msvc.git
   git clone https://github.com/SamuelMarks/dash-windows.git
   ```

2. Configure and build via CMake:
   ```cmd
   cd dash-windows
   cmake -B build -S . -DFETCHCONTENT_SOURCE_DIR_AUTO_WIN_MSVC=../auto-win-msvc
   cmake --build build --config Release
   ```

3. Test the built shell:
   ```cmd
   build\\dash_build\\Release\\dash.exe -c "echo Hello from native DASH on Windows!"
   ```

---

## License

Licensed under either of:
- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT License ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)
- Creative Commons Zero 1.0 Universal ([LICENSE-CC0](LICENSE-CC0) or https://creativecommons.org/publicdomain/zero/1.0/)

at your option.
