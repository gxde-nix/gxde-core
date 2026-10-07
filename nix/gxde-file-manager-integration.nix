{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  gxde-file-manager,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-file-manager-integration";
  version = "0.2.2-1";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-file-manager-integration";
    rev = "e551d49f63459b6eff8b2681b66b1ac8d5cd777c";
    hash = "sha256-1F+45IHX0Xg76E930lLGv2Y6jXdyApZNQIB3/YdjyLM=";
  };
  dontWrapQtApps = true;
  patches = [ ./patches/gxde-file-manager-integration/0001-fedora-libdir.patch ];
  nativeBuildInputs = [
    pkg-config
    qt6.qtbase
    qt6.qttools
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    qt6.qtwebengine
    gxde-file-manager
  ];
  configurePhase = ''
    runHook preConfigure
    qmake6 dde-file-manager-integration.pro \
      DAPP_VERSION=${finalAttrs.version} \
      LIB_INSTALL_DIR=$out/lib
    runHook postConfigure
  '';
  installPhase = ''
    runHook preInstall
    make install INSTALL_ROOT=${placeholder "out"}
    for d in bin lib libexec share etc; do
      if [ -d $out/usr/$d ]; then
        mkdir -p $out/$d
        cp -a $out/usr/$d/. $out/$d/
      fi
    done
    rm -rf $out/usr
    runHook postInstall
  '';
  meta = {
    description = "Optional plugins for the GXDE file manager";
    homepage = "https://github.com/GXDE-OS/gxde-file-manager-integration";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
