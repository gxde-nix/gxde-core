{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt5,
  polkit-qt,
  dtk2core,
  dtk2widget,
  dde-qt-dbus-factory,
  dpa-ext-gnomekeyring,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-polkit-agent";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-polkit-agent";
    rev = "3d80ef854a28bb47874fc1568bc835ca5373552f";
    hash = "sha256-pvTiLw2Ah8R3kKT2suBqKGiwlrfcQThEFNWOnaEEhTM=";
  };

  dontWrapQtApps = true;

  patches = [ ./patches/gxde-polkit-agent/0001-fedora-dtk2-build.patch ];

  nativeBuildInputs = [
    pkg-config
    qt5.qtbase
    qt5.qttools
  ];

  buildInputs = [
    qt5.qtbase
    polkit-qt
    dtk2core
    dtk2widget
    dde-qt-dbus-factory
    dpa-ext-gnomekeyring
  ];

  configurePhase = ''
    runHook preConfigure
    qmake dde-polkit-agent.pro
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    make install INSTALL_ROOT=${placeholder "out"}

    for d in bin lib libexec share include; do
      if [ -d $out/usr/$d ]; then
        mkdir -p $out/$d
        cp -a $out/usr/$d/. $out/$d/
      fi
    done
    rm -rf $out/usr

    runHook postInstall
  '';

  meta = {
    description = "GXDE PolicyKit authentication agent";
    homepage = "https://github.com/GXDE-OS/gxde-polkit-agent";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
