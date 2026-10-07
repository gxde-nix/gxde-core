{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  xcursorgen,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-icon-theme";
  version = "2026.03.20";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-icon-theme";
    rev = "2b36f58828baa3c2e887451a67aefbde5af54efa";
    hash = "sha256-peJWl1R/c3ZUsYZwZEEUcQ7v+OT0iXv06Lw3EUf+IXI=";
  };

  nativeBuildInputs = [
    gtk3
    xcursorgen
  ];

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a gxde gxde-dark gxde-Sea deepin $out/share/icons/

    runHook postInstall
  '';

  meta = {
    description = "GXDE icon theme";
    homepage = "https://github.com/GXDE-OS/gxde-icon-theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
