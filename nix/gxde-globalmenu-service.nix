{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  libxcb,
  libxcb-util,
  libxdmcp,
  libXau,
  libsysprof-capture,
  util-linux,
  libselinux,
  libsepol,
  kwindowsystem,
  kconfig-kf5,
  kcoreaddons-kf5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-globalmenu-service";
  version = "1.1.0gxde3-2";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-globalmenu-service";
    rev = "e430e242b33effe9901a46f5f446ac35a3d77150";
    hash = "sha256-ST0xl1x+BKgXeJJAavcRQpL8y7oNqWkHghTxr3/Hnqo=";
  };
  dontWrapQtApps = true;
  patches = [ ./patches/gxde-globalmenu-service/0001-native-install-rules.patch ];
  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qttools
  ];
  env.CMAKE_PREFIX_PATH = lib.concatStringsSep ":" [ kconfig-kf5.dev kcoreaddons-kf5.dev ];

  buildInputs = [
    kwindowsystem
    libsForQt5.qtbase
    libsForQt5.qtx11extras
    libxcb
    libxcb-util
    libxdmcp
    libXau
    libsysprof-capture
    util-linux
    libselinux
    libsepol
  ];
  meta = {
    description = "GXDE global menu service";
    homepage = "https://github.com/GXDE-OS/gxde-globalmenu-service";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
