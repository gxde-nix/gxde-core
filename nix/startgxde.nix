{
  lib,
  stdenv,
  fetchFromGitHub,
  go,
  pkg-config,
  jq,
  libX11,
  libXcursor,
  libXfixes,
  libgnome-keyring,
  pulseaudio,
  glib,
  gtk3,
  libgudev,
  systemdLibs,
  libsecret,
  dbus,
  alsa-lib,
  golang-gxde-dev,
  gxde-api,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "startgxde";
  version = "4.0.18";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "startgxde";
    rev = "b9589ea6e14ace073bb6442eaddc1ebe4ca6aa0c";
    hash = "sha256-UnD0z6hQaHK0DypJYL5lPKlxYv/bdJTMS2XzDvMT72c=";
  };

  patches = [ ./patches/startgxde/0001-pie-build-order.patch ];

  nativeBuildInputs = [
    go
    pkg-config
    jq
  ];

  buildInputs = [
    libX11
    libXcursor
    libXfixes
    libgnome-keyring
    pulseaudio
    glib
    gtk3
    libgudev
    systemdLibs
    libsecret
    dbus
    alsa-lib
    golang-gxde-dev
    gxde-api
  ];

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

    make GOPATH="${finalAttrs.gopath}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install DESTDIR=$out PREFIX= GOPATH="${finalAttrs.gopath}"

    install -Dm0755 ${./files/startgxde/startgxde-fedora} $out/bin/startgxde

    for f in $out/share/xsessions/*.desktop; do
      [ -e "$f" ] || continue
      substituteInPlace "$f" --replace-fail '/bin/startdde' '/bin/startgxde'
    done

    install -Dm0644 misc/00deepin-dde-env $out/share/startdde/00deepin-dde-env
    rm -rf $out/etc/X11/Xsession.d $out/share/lightdm

    runHook postInstall
  '';

  meta = {
    description = "GXDE session starter";
    homepage = "https://github.com/GXDE-OS/startgxde";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
