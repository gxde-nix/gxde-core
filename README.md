# GXDE Core
Core desktop packages of the GXDE desktop environment: themes and artwork, the application installer/upgrader/uninstaller helpers, system daemons, the Wayland compositor, the dock, the top panel and its plugins, the control center, the launcher, the session UI, the file manager family, the compressors and the screensavers.

## Version
| flake attr | version | upstream | rev |
| --- | --- | --- | --- |
| `deepin-daemon` | 4.0.16 | GXDE-OS/deepin-daemon | `9b59dbed` |
| `deepin-gtk-theme` | 26.0.0 | GXDE-OS/deepin-gtk-theme | `2cf8f624` |
| `deepin-installer-timezones` | 2.7.23 | GXDE-OS/deepin-installer-reborn | `819c934e` |
| `deepin-menu` | 6.0.1 | GXDE-OS/deepin-menu | `f5beaf99` |
| `deepin-screensaver` | 6.5.12 | GXDE-OS/deepin-screensaver | `9c225144` |
| `dpa-ext-gnomekeyring` | 0.1.1 | GXDE-OS/dpa-ext-gnomekeyring | `2e8085f6` |
| `extra-cmake-modules-kf5` | 5.116.0 | GXDE-OS/extra-cmake-modules | `v5.116.0` |
| `garma` | 2.0.0 | GXDE-OS/garma | `d889ff03` |
| `gxde-account-faces` | 1.0.12.2 | GXDE-OS/gxde-account-faces | `de8b351c` |
| `gxde-app-installer` | 1.1.2 | GXDE-OS/gxde-app-installer | `4b443404` |
| `gxde-app-uninstaller` | 1.6.3 | GXDE-OS/gxde-app-uninstaller | `a65404a5` |
| `gxde-app-upgrader` | 1.6.5 | GXDE-OS/gxde-app-upgrader | `2c88f619` |
| `gxde-artwork` | 2024.08.25 | GXDE-OS/gxde-artwork | `c7401811` |
| `gxde-compressor` | 1.6.0 | GXDE-OS/gxde-compressor | `d8b054f5` |
| `gxde-control-center` | 6.0.24 | GXDE-OS/gxde-control-center | `c402db81` |
| `gxde-daemon` | 1.3.13 | GXDE-OS/gxde-daemon | `a2a91dce` |
| `gxde-default-settings` | 2026.06.25-1 | GXDE-OS/gxde-default-settings | `f31c85eb` |
| `gxde-dock` | 6.0.24 | GXDE-OS/gxde-dock | `64c81263` |
| `gxde-file-manager-integration` | 0.2.2-1 | GXDE-OS/gxde-file-manager-integration | `e551d49f` |
| `gxde-file-manager` | 6.4.10 | GXDE-OS/gxde-file-manager | `ca3f2d31` |
| `gxde-globalmenu-service` | 1.1.0gxde3-2 | GXDE-OS/gxde-globalmenu-service | `e430e242` |
| `gxde-icon-theme` | 2026.03.20 | GXDE-OS/gxde-icon-theme | `2b36f588` |
| `gxde-launcher` | 6.0.22 | GXDE-OS/gxde-launcher | `3b216664` |
| `gxde-polkit-agent` | 1.0.2 | GXDE-OS/gxde-polkit-agent | `3d80ef85` |
| `gxde-requ` | 1.4.5 | GXDE-OS/gxde-requ | `2996c03e` |
| `gxde-session-ui` | 5.1.6 | GXDE-OS/gxde-session-ui | `76039e86` |
| `gxde-shell-compressor` | 1.4.2 | GXDE-OS/gxde-shell-compressor | `453a12c9` |
| `gxde-shell-tools` | 1.0.2 | GXDE-OS/gxde-shell-tools | `4572768c` |
| `gxde-sni-server` | 1.0.0 | GXDE-OS/gxde-sni-server | `b4bddd71` |
| `gxde-sound-theme` | 25.0u1 | GXDE-OS/gxde-sound-theme | `557be949` |
| `gxde-time-screensaver` | 1.2.2 | GXDE-OS/gxde-time-screensaver | `1b53f0b1` |
| `gxde-top-panel-plugins` | 6.1.1 | GXDE-OS/gxde-top-panel-plugins | `d906ed40` |
| `gxde-top-panel` | 2.0.1 | GXDE-OS/gxde-top-panel | `4cfc6f95` |
| `gxde-wallpapers` | 1.7.49 | GXDE-OS/gxde-wallpapers | `31699510` |
| `gxde-wlcom` | 2.3.7-gxde4 | GXDE-OS/gxde-wlcom | `f75991d4` |
| `kconfig-kf5` | 5.116.0 | GXDE-OS/kconfig | `v5.116.0` |
| `kcoreaddons-kf5` | 5.116.0 | GXDE-OS/kcoreaddons | `v5.116.0` |
| `kwindowsystem-kf5` | 5.116.0 | GXDE-OS/kwindowsystem | `v5.116.0` |
| `open-kylin-wlroots` | 0.17.4-unstable-2026-10-03 | GXDE-OS/open-kylin-wlroots | `950dbeb6` |
| `startgxde` | 4.0.18 | GXDE-OS/startgxde | `b9589ea6` |
| `transhell` | 1.1.0 | GXDE-OS/transhell | `12543a71` |
| `zipu` | 1.0.0 | GXDE-OS/zipu | `14cba98c` |

## Notes
- Cross-repository dependencies come from flakes instead of being duplicated: [gxde-nix/gxde-dtk5](https://github.com/gxde-nix/gxde-dtk5), [gxde-nix/gxde-dtk6](https://github.com/gxde-nix/gxde-dtk6), [gxde-nix/gxde-dtk2](https://github.com/gxde-nix/gxde-dtk2) and [gxde-nix/gxde-infras](https://github.com/gxde-nix/gxde-infras).
- The Qt6 libraries published by `gxde-infras` hardcode the `out` output into their `pkg-config` and CMake files, while the headers live in the `dev` output. Every consumer therefore runs through the `fixQt6Paths` helper in `default.nix`, which rewrites those files to absolute `dev` paths after the outputs are split. The same class of problem is also worked around for `dtk6core` (its CMake config looks for `libexec/dtk6/DCore/bin/deepin-os-release` in the `dev` output) and for `gxde-dock` (whose installed `pluginsiteminterface.h` misses the `Q_DECLARE_INTERFACE` entry that its consumers rely on).
- Several projects have moved on since GXDE's Fedora packaging: the Fedora patches under `nix/patches/` are only applied where they still apply at the pinned tag, and the parts that no longer apply are reproduced in `postPatch`/`preConfigure` (Qt6 private targets, `dframeworkdbus` → `dframeworkdbus-qt6`, `lupdate`/`lrelease` paths, `DESTINATION /usr` install paths and the DBus interfaces the file manager expects).
- `gxde-file-manager` needs a handful of Nix-side adaptations: `find_package(Dtk6 ...)` is injected into the CMake files that use bare DTK headers, the DBus interface the desktop panel expects is generated with `qdbusxml2cpp` and wired into the target, the absolute install destinations of the generated `cmake_install.cmake` files are rewritten and one `.desktop` file that upstream references but does not ship is provided. `gxde-file-manager-integration` builds on top of it.
- `gxde-session-ui` builds both Qt5 and Qt6 in one CMake run (`dde-shutdown` and `dde-osd` are Qt6 while the parent project locks Qt5). That is possible here because the Qt6 base is brought in with its setup hook removed, its paths are passed through `CMAKE_PREFIX_PATH`/`QT6_CMAKE_DIR`, and `lupdate`/`lrelease` are pointed at the right outputs. `gxde-globalmenu-service` needs KF5, which current nixpkgs no longer ships, so `extra-cmake-modules`, `kwindowsystem`, `kconfig` and `kcoreaddons` are built from KDE's last KF5 release (5.116.0) against nixpkgs' Qt5 by this repository.
- `gxde-wallpapers` builds its wallpapers with `image-blur` from `gxde-api`; the hardcoded `/usr/lib/deepin-api` path is redirected to the Nix store.
- The application helpers (`gxde-app-installer`, `gxde-app-upgrader`, `gxde-app-uninstaller`) are script packages: their Fedora-only sources (`*-fedora`, the systemd units and the polkit policies) are vendored under `nix/files/`, and their `PATH` is assembled with `makeWrapper`. `dnf5`, which the scripts call at runtime, is not packaged in nixpkgs.

## Building via Script
### Basic Instructions
```bash
$ chmod a+x ./build-nix
$ ./build-nix
```

### Usage
```
Usage: build-nix [options] [target]

Build a Nix package from the current directory.

Options:
  -L, --log       Show full build logs.
      --rebuild   Rebuild to check reproducibility.
      --cleanup   Cleanup results.
  -h, --help      Print help page.

Target:
  A .nix file or a flake installable, such as .#package.
  Defaults to the target where this script is in.
```

## Licensing
(C) 2026 CharOfString.

The packaging in this repository — the Nix expressions, `build-nix` and the documentation — is licensed under [MIT](./LICENSE).

The files under `nix/patches/` modify sources of the corresponding upstream projects and are provided under those projects' licenses; all of them originate from GXDE's Fedora packaging:

| upstream project | license |
| --- | --- |
| GXDE-OS/golang-gxde-dev, gxde-api, gxde-desktop-base, dframework-dbus-qt6, gxde-network-utils-qt6, gxde-k9, deepin-daemon, gxde-daemon, gxde-wlcom, startgxde, deepin-menu, gxde-polkit-agent, gxde-sni-server, gxde-dock, gxde-top-panel, gxde-top-panel-plugins, gxde-control-center, gxde-launcher, gxde-file-manager, gxde-time-screensaver, deepin-screensaver | GPL-3.0-or-later |
| GXDE-OS/libdbusmenu-qt6, gxde-session-ui, gxde-globalmenu-service | LGPL-2.1-only / LGPL-3.0-or-later |
| GXDE-OS/disomaster-qt6, udisks2-qt6 | GPL-3.0-or-later | 
