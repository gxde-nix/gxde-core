let
  fromDtk2Widget = name: pkg:
    builtins.head (builtins.filter
      (p: builtins.isAttrs p && (p.pname or null) == name)
      pkg.buildInputs);
in
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  dtk2widget-qt6,
  dframework-dbus-qt6,
  gsettings-qt6,
  dtk6core ? fromDtk2Widget "dtk6core" dtk2widget-qt6,
  dtk6log ? fromDtk2Widget "dtk6log" dtk2widget-qt6,
  libxcb-wm,
  libX11,
  libXext,
  libxdmcp,
  libsysprof-capture,
  util-linux,
  libselinux,
  libsepol,
  libXau,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dde-osd";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-session-ui";
    rev = "76039e86b769e54c2dd527652418405a6020d29f";
    hash = "sha256-kbUGm5wd0WhGUT9bCuz4+vNrii4MNnVIHlWgOJcX31k=";
  };

  dontWrapQtApps = true;
  cmakeDir = "../dde-osd";

  env.CMAKE_PREFIX_PATH = lib.concatStringsSep ":" [
    qt6.qtbase
    qt6.qtbase.dev
    qt6.qtsvg
    qt6.qtsvg.dev
    qt6.qttools
    qt6.qttools.dev
    dtk2widget-qt6
    dtk2widget-qt6.dev
    dframework-dbus-qt6
    dframework-dbus-qt6.dev
    kdePackages.layer-shell-qt
    kdePackages.layer-shell-qt.dev
    kdePackages.kwindowsystem
    kdePackages.kwindowsystem.dev
  ];
  env.NIX_CFLAGS_COMPILE = "-Wno-error -Wno-error=deprecated-declarations -I${gsettings-qt6.dev}/include/qt6";

  postPatch = ''
    ln -s ../global_util dde-osd/global_util
    substituteInPlace dde-osd/CMakeLists.txt \
      --replace-fail 'find_package(PkgConfig REQUIRED)' \
      'cmake_minimum_required(VERSION 3.7)
project(dde-osd LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(PREFIX "''${CMAKE_INSTALL_PREFIX}")
find_package(PkgConfig REQUIRED)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kdePackages.layer-shell-qt
    kdePackages.kwindowsystem
    gsettings-qt6
    dtk2widget-qt6
    dframework-dbus-qt6
    dtk6core
    dtk6log
    libX11
    libXext
    libxcb-wm
    libxdmcp
    libsysprof-capture
    util-linux
    libselinux
    libsepol
    libXau
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
  ];

  postInstall = ''
    substituteInPlace $out/share/dbus-1/services/com.deepin.dde.osd.service \
      --replace-fail '/usr/lib/deepin-daemon/dde-osd' "$out/lib/deepin-daemon/dde-osd"
  '';

  meta = {
    description = "GXDE OSD and notification daemon (Qt6)";
    homepage = "https://github.com/GXDE-OS/gxde-session-ui";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
