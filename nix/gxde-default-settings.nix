{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  xdg-user-dirs,
  gxde-artwork,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-default-settings";
  version = "2026.06.25-1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-default-settings";
    rev = "f31c85eb1a4aaada60909bec3121a2f1b9c2bc29";
    hash = "sha256-JeyLVsy8UqCscBUSVzpyOOwUFp2MTuEXyc7OxKQ6LgE=";
  };

  patches = [ ./patches/gxde-default-settings/0001-fedora-first-run.patch ];

  nativeBuildInputs = [ python3 ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dpm0755 dde-first-run $out/bin/dde-first-run
    install -Dpm0644 usr.share.d/deepin-default-settings/fontconfig.json \
      $out/share/deepin-default-settings/fontconfig.json

    mkdir -p $out/share/fontconfig/conf.avail
    cp usr.share.d/fontconfig/conf.avail/*.conf $out/share/fontconfig/conf.avail/

    install -Dpm0644 usr.share.d/applications/deepin/dde-mimetype.list \
      $out/share/applications/deepin/dde-mimetype.list
    install -Dpm0644 usr.share.d/applications/mimeapps.list \
      $out/etc/xdg/gxde-mimeapps.list
    sed -i 's|=/usr/share/applications/|=|g' $out/etc/xdg/gxde-mimeapps.list

    install -Dpm0644 usr.share.d/mime/packages/deepin-workaround.xml \
      $out/share/mime/packages/deepin-workaround.xml
    install -Dpm0644 etc.d/skel/.config/deepin/qt-theme.ini \
      $out/etc/xdg/gxde/deepin/qt-theme.ini

    runHook postInstall
  '';

  propagatedBuildInputs = [
    xdg-user-dirs
    gxde-artwork
  ];

  meta = {
    description = "Default settings and mime configuration for GXDE";
    homepage = "https://github.com/GXDE-OS/gxde-default-settings";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
