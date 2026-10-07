{
  lib,
  stdenv,
  fetchFromGitHub,
  deepin-gtk-theme,
  gxde-icon-theme,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-artwork";
  version = "2024.08.25";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-artwork";
    rev = "c7401811534da980a05d784d08179ba19faa93ec";
    hash = "sha256-2yAOeuGbFJmgGkICjmrLiZ7NCONyMMjwHGEDoHX1Gek=";
  };

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace etc/gtk-2.0/gtkrc \
      --replace-fail 'gtk-icon-themename' 'gtk-icon-theme-name' \
      --replace-fail '="Deepin"' '="deepin"'
  '';

  installPhase = ''
    runHook preInstall

    install -Dpm0644 etc/gtk-2.0/gtkrc $out/etc/xdg/gxde/gtk-2.0/gtkrc
    install -d $out/etc/xdg/gxde/gtk-3.0
    cat > $out/etc/xdg/gxde/gtk-3.0/settings.ini <<'SETTINGS'
    [Settings]
    gtk-theme-name=deepin
    gtk-icon-theme-name=gxde
    SETTINGS

    runHook postInstall
  '';

  propagatedBuildInputs = [
    deepin-gtk-theme
    gxde-icon-theme
  ];

  meta = {
    description = "GXDE GTK artwork and session theme defaults";
    homepage = "https://github.com/GXDE-OS/gxde-artwork";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
