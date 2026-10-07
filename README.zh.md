# GXDE Core
GXDE 桌面环境的核心包：主题与素材、应用安装/升级/卸载助手、系统守护进程、Wayland 合成器、任务栏、顶栏及其插件、控制中心、启动器、会话界面、文件管理器全家、压缩工具与屏保。

## 版本
| flake attr | 版本 | 上游 | rev |
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

## 说明
- 跨仓依赖走 flake input，不在本仓重造：[gxde-nix/gxde-dtk5](https://github.com/gxde-nix/gxde-dtk5)、[gxde-nix/gxde-dtk6](https://github.com/gxde-nix/gxde-dtk6)、[gxde-nix/gxde-dtk2](https://github.com/gxde-nix/gxde-dtk2)、[gxde-nix/gxde-infras](https://github.com/gxde-nix/gxde-infras)。
- `gxde-infras` 里的 Qt6 库把 `out` 输出硬编码进了 `pkg-config`/CMake 文件，而头文件在 `dev` 输出里。因此所有消费者都经过 `default.nix` 里的 `fixQt6Paths`：在输出拆分之后把这些文件改写成 dev 的绝对路径。同类问题还处理了 `dtk6core`（它的 CMake 配置在 dev 里找 `libexec/dtk6/DCore/bin/deepin-os-release`）和 `gxde-dock`（安装出来的 `pluginsiteminterface.h` 少了消费者依赖的 `Q_DECLARE_INTERFACE` 声明）。
- 有些项目已经跑在 GXDE 的 Fedora 打包之前：`nix/patches/` 下的 Fedora 补丁只在 pin 的 tag 上仍然适用时才用，失效的部分改在 `postPatch`/`preConfigure` 里重现（Qt6 私有目标、`dframeworkdbus` → `dframeworkdbus-qt6`、`lupdate`/`lrelease` 路径、`DESTINATION /usr` 安装路径，以及文件管理器需要的 DBus 接口）。
- `gxde-file-manager` 需要若干 Nix 侧适配：在使用裸 DTK 头的 CMake 文件里注入 `find_package(Dtk6 ...)`；用 `qdbusxml2cpp` 生成桌面面板需要的 DBus 接口并挂进目标；改写生成的 `cmake_install.cmake` 里的绝对安装路径；补一个上游引用但未随源码发布的 `.desktop` 文件。`gxde-file-manager-integration` 建立在它之上。
- `gxde-session-ui` 在一次 CMake 里同时编 Qt5 和 Qt6（`dde-shutdown`、`dde-osd` 是 Qt6，父工程锁定 Qt5）。这里的做法是：引入一份去掉 setup hook 的 Qt6 base，用 `CMAKE_PREFIX_PATH`/`QT6_CMAKE_DIR` 传路径，并把 `lupdate`/`lrelease` 指到正确的输出。`gxde-globalmenu-service` 需要 KF5，而当前 nixpkgs 已不再提供，因此本仓库用 KDE 最后一个 KF5 版本（5.116.0）的 `extra-cmake-modules`、`kwindowsystem`、`kconfig`、`kcoreaddons` 与 nixpkgs 的 Qt5 一起编译。
- `gxde-wallpapers` 用 `gxde-api` 的 `image-blur` 生成壁纸，写死的 `/usr/lib/deepin-api` 路径已重定向到 Nix store。
- 应用三件套（`gxde-app-installer`/`gxde-app-upgrader`/`gxde-app-uninstaller`）是脚本包：Fedora 专属的源码（`*-fedora`、systemd unit、polkit policy）放在 `nix/files/` 下，PATH 用 `makeWrapper` 装配。脚本运行时调用的 `dnf5` 在 nixpkgs 里没有。

## 使用脚本构建
### 基本使用
```bash
$ chmod a+x ./build-nix
$ ./build-nix
```

### 使用说明
```
用法: build-nix [选项] [目标]

从本地目录构建Nix包。

选项:
  -L, --log       构建时打印日志
      --rebuild   重新构建以检查可复现性
      --cleanup   清理产物
  -h, --help      打印帮助

目标:
  一个.nix文件或者flake installable，例如.#package。
  默认在当前目录查找。
```

## 许可证
(C) 2026 CharOfString.

本仓库的打包部分（Nix 表达式、`build-nix`、文档）以 [MIT](./LICENSE) 协议授权。

`nix/patches/` 下的文件修改的是对应上游项目的源码，按**原仓库协议**提供，均来自 GXDE 的 Fedora 打包：

| 上游项目 | 协议 |
| --- | --- |
| GXDE-OS/golang-gxde-dev、gxde-api、gxde-desktop-base、dframework-dbus-qt6、gxde-network-utils-qt6、gxde-k9、deepin-daemon、gxde-daemon、gxde-wlcom、startgxde、deepin-menu、gxde-polkit-agent、gxde-sni-server、gxde-dock、gxde-top-panel、gxde-top-panel-plugins、gxde-control-center、gxde-launcher、gxde-file-manager、gxde-time-screensaver、deepin-screensaver | GPL-3.0-or-later |
| GXDE-OS/libdbusmenu-qt6、gxde-session-ui、gxde-globalmenu-service | LGPL-2.1-only / LGPL-3.0-or-later |
| GXDE-OS/disomaster-qt6、udisks2-qt6 | GPL-3.0-or-later |
