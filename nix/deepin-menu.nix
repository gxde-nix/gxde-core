{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  kdePackages,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6log,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepin-menu";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "deepin-menu";
    rev = "f5beaf99d5118be8617abb9f03f88c581d8e0c7a";
    hash = "sha256-vo0plQig9BuIRt4X5+2LJtI13MvkTQV2ILLFcsipSdE=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    qt6.qtbase
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    kdePackages.layer-shell-qt
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6log
  ];

  configurePhase = ''
    runHook preConfigure
    qmake6 deepin-menu.pro
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    make install INSTALL_ROOT=${placeholder "out"}

    mkdir -p $out/bin $out/share
    mv $out/usr/bin/* $out/bin/
    cp -a $out/usr/share/. $out/share/
    rm -rf $out/usr

    runHook postInstall
  '';

  meta = {
    description = "GXDE application menu service";
    homepage = "https://github.com/GXDE-OS/deepin-menu";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
