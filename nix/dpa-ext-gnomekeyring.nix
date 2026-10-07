{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt5,
  libgnome-keyring,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dpa-ext-gnomekeyring";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dpa-ext-gnomekeyring";
    rev = "2e8085f66027764ddc8ac930c4f6e988b28ce123";
    hash = "sha256-qQPI4bdeQiAX8LIuS1qVreI9kIOkgYZhm1AjMEMxtsc=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    qt5.qtbase
    qt5.qttools
  ];

  buildInputs = [
    qt5.qtbase
    libgnome-keyring
  ];

  postPatch = ''
    cp ${./files/dpa-ext-gnomekeyring/dpa-ext-gnomekeyring.pro} dpa-ext-gnomekeyring.pro
    mkdir -p include/dpa
    cp ${./files/dpa-ext-gnomekeyring/agent-extension.h} include/dpa/agent-extension.h
    cp ${./files/dpa-ext-gnomekeyring/agent-extension-proxy.h} include/dpa/agent-extension-proxy.h
  '';

  configurePhase = ''
    runHook preConfigure
    qmake dpa-ext-gnomekeyring.pro
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make
    for ts in translations/*.ts; do lrelease "$ts"; done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 libdpa-ext-gnomekeyring.so \
      $out/lib/polkit-1-dde/plugins/libdpa-ext-gnomekeyring.so
    mkdir -p $out/share/dpa-ext-gnomekeyring/translations
    install -m0644 translations/*.qm $out/share/dpa-ext-gnomekeyring/translations/

    runHook postInstall
  '';

  meta = {
    description = "PolicyKit agent extension for GNOME Keyring";
    homepage = "https://github.com/GXDE-OS/dpa-ext-gnomekeyring";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
