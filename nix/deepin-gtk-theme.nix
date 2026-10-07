{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepin-gtk-theme";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "deepin-gtk-theme";
    rev = "2cf8f6248e74cf8b539c518b6eced19810642b83";
    hash = "sha256-v//2plXnBXa8ObPV2lAzWAHE0xSDdthunWSYrAu3yd8=";
  };

  dontConfigure = true;
  dontBuild = true;

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = {
    description = "Deepin/GXDE GTK theme";
    homepage = "https://github.com/GXDE-OS/deepin-gtk-theme";
    license = with lib.licenses; [ gpl3Plus lgpl21Only ];
    platforms = lib.platforms.linux;
  };
})
