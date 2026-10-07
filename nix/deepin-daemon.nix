{
  lib,
  stdenv,
  fetchFromGitHub,
  go,
  python3,
  pkg-config,
  makeWrapper,
  gtk3,
  gdk-pixbuf,
  gdk-pixbuf-xlib,
  librsvg,
  libgudev,
  systemdLibs,
  linux-pam,
  libxcrypt,
  pulseaudio,
  alsa-lib,
  libinput,
  libevdev,
  libwacom,
  mtdev,
  dbus,
  libsecret,
  libcap,
  libnl,
  golang-gxde-dev,
  gxde-api,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepin-daemon";
  version = "4.0.16";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "deepin-daemon";
    rev = "9b59dbed7afab6572c97fd1c5282cd4ccafdf520";
    hash = "sha256-dN7WxpAe/iS7ogmXoJG4PEoI9FvW+YTfvnWIeRt/RJw=";
  };

  patches = [ ./patches/deepin-daemon/0001-fedora-build-and-authentication.patch ];

  nativeBuildInputs = [
    go
    python3
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    gdk-pixbuf-xlib
    librsvg
    libgudev
    systemdLibs
    linux-pam
    libxcrypt
    pulseaudio
    alsa-lib
    libinput
    libevdev
    libwacom
    mtdev
    dbus
    libsecret
    libcap
    libnl
    golang-gxde-dev
    gxde-api
  ];

  postPatch = ''
    cp ${./files/deepin-daemon/compile-policy-translations.py} compile-policy-translations.py
    cp ${./files/deepin-daemon/gxde-lock.pam} gxde-lock.pam
  '';

  gopath = lib.concatStringsSep ":" [
    "${golang-gxde-dev}/share/gocode-gxde"
    "$PWD/gopath"
  ];

  buildPhase = ''
    runHook preBuild

    export GO111MODULE=off
    export GOPROXY=off
    export GOTOOLCHAIN=local
    export GOFLAGS="-trimpath -buildvcs=false"
    export GOCACHE="$TMPDIR/gocache"
    export CGO_CFLAGS="$CFLAGS -std=gnu17"
    export CGO_LDFLAGS="$LDFLAGS"

    python3 compile-policy-translations.py

    make prepare
    make build translate GOPATH="${finalAttrs.gopath}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install \
      GOPATH="${finalAttrs.gopath}" \
      DESTDIR=$out \
      PREFIX=

    runHook postInstall
  '';

  meta = {
    description = "GXDE system daemon";
    homepage = "https://github.com/GXDE-OS/deepin-daemon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
