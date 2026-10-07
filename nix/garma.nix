{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libxcb,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6log,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "garma";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "garma";
    rev = "d889ff0315b6e87a14d5554e46f048384864d186";
    hash = "sha256-AL8TK1FAagYhI6vtGiGET37ytDn5+d/XDSDMW8Tk5sI=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    libxcb
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6log
  ];

  postPatch = ''
    for ts in translations/*.ts; do
      [ -e "$ts" ] || continue
      lrelease "$ts"
    done
  '';

  meta = {
    description = "Garma dialog utility for GXDE's DTK/Qt6 applications";
    homepage = "https://github.com/GXDE-OS/garma";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
