{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
  pkg-config,
  libX11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-time-screensaver";
  version = "1.2.2";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-time-screensaver";
    rev = "1b53f0b159727eb46c338af92c10f2ef8c26a5b6";
    hash = "sha256-4vqdVJhT0tjDzcV6z/d9/Y1L2bLzVW/dssYGeEjBUvc=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [ pkg-config qt5.qtbase qt5.qttools ];
  buildInputs = [ qt5.qtbase libX11 ];
  configurePhase = ''
    runHook preConfigure
    qmake PREFIX=$out
    runHook postConfigure
  '';
  installPhase = ''
    runHook preInstall
    make install INSTALL_ROOT=${placeholder "out"}
    for d in bin lib share; do
      if [ -d $out/usr/$d ]; then
        mkdir -p $out/$d
        cp -a $out/usr/$d/. $out/$d/
      fi
    done
    rm -rf $out/usr
    runHook postInstall
  '';
  meta = {
    description = "GXDE time screensaver";
    homepage = "https://github.com/GXDE-OS/gxde-time-screensaver";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
