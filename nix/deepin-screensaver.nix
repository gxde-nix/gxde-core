{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libX11,
  libxcb,
  libXext,
  libXScrnSaver,
  dtk6core,
  dtk6gui,
  dtk6widget,
  gxde-time-screensaver,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepin-screensaver";
  version = "6.5.12";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "deepin-screensaver";
    rev = "9c2251449438764f99a0243920fee13efd7ca203";
    hash = "sha256-MzJcZaEv67awMGBtxoTgbHlmOv6LQBr6L9l/C+vrhlc=";
  };
  dontWrapQtApps = true;
  postPatch = ''
    find . -name CMakeLists.txt -print0 | while IFS= read -r -d "" f; do
      sed -i -E 's|DESTINATION /usr/|DESTINATION |g; s|DESTINATION /etc/|DESTINATION etc/|g' "$f"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qt5compat
    libX11
    libxcb
    libXext
    libXScrnSaver
    dtk6core
    dtk6gui
    dtk6widget
    gxde-time-screensaver
  ];
  cmakeFlags = [
    "-DQT_VERSION_MAJOR=6"
    "-DQt6_LRELEASE_EXECUTABLE=${qt6.qttools}/bin/lrelease"
  ];
  meta = {
    description = "GXDE screensaver";
    homepage = "https://github.com/GXDE-OS/deepin-screensaver";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
