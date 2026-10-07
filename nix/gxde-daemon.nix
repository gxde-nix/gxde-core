{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  libsysprof-capture,
  wayland-scanner,
  gdk-pixbuf,
  cjson,
  wayland,
  libxcb,
  libxcb-wm,
  gxde-wlcom,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-daemon";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-daemon";
    rev = "a2a91dce1a98b2eb62a99a82ea6d83c6c142fe2e";
    hash = "sha256-hTw14lp+aD2HEhUGQ9xn5SaaqiqNjj8NeQ5lyfl8hq4=";
  };

  dontWrapQtApps = true;
  dontConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    libsysprof-capture
    wayland-scanner
    gdk-pixbuf
    cjson
    wayland
    libxcb
    libxcb-wm
    gxde-wlcom
  ];

  buildPhase = ''
    runHook preBuild

    for plugin in dock daemon-manager gtk-theme-inject; do
      cmake -S plugins/$plugin -B build-$plugin \
        -DCMAKE_INSTALL_PREFIX=${placeholder "out"}
      cmake --build build-$plugin
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for plugin in dock daemon-manager gtk-theme-inject; do
      DESTDIR=$out cmake --install build-$plugin
    done

    mkdir -p $out/bin $out/libexec/gxde-daemon
    cp -a bin/. $out/bin/
    cp -a libexec/gxde-daemon/. $out/libexec/gxde-daemon/
    cp -a gxde-daemon/. $out/libexec/gxde-daemon/
    if [ -d share ]; then
      mkdir -p $out/share
      cp -a share/. $out/share/
    fi

    runHook postInstall
  '';

  meta = {
    description = "GXDE desktop daemon and its session plugins";
    homepage = "https://github.com/GXDE-OS/gxde-daemon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
