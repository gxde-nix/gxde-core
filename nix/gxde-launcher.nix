{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  gsettings-qt6,
  wayland,
  libxcb,
  libX11,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6log,
  dframework-dbus-qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-launcher";
  version = "6.0.22";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-launcher";
    rev = "3b21666411cc99984efaa00d9c6692a12534ca38";
    hash = "sha256-kwoP/TAeofxi1rsnrKZh16JXYD/Pi7hAVrJGENzjAqE=";
  };
  dontWrapQtApps = true;
  patches = [
    ./patches/gxde-launcher/0001-use-fedora-qt6-tools.patch
    ./patches/gxde-launcher/0002-use-qt-private-target-and-fedora-flags.patch
  ];
  nativeBuildInputs = [ cmake pkg-config qt6.qttools ];
  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    kdePackages.layer-shell-qt
    gsettings-qt6
    wayland
    libxcb
    libX11
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6log
    dframework-dbus-qt6
  ];
  postPatch = ''
    find . -name CMakeLists.txt -print0 | while IFS= read -r -d "" f; do
      sed -i -E 's#DESTINATION /usr/#DESTINATION #g; s#DESTINATION /etc/#DESTINATION etc/#g' "$f"
    done

    for f in $(find . -name 'translate_generation.sh'); do
      substituteInPlace "$f" \
        --replace '/usr/lib64/qt6/bin/lupdate' '${qt6.qttools}/bin/lupdate' \
        --replace '/usr/lib64/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease'
    done
  '';
  postInstall = ''
    for f in $out/lib/pkgconfig/*.pc $out/share/pkgconfig/*.pc; do
      [ -e "$f" ] || continue
      sed -i 's|//nix/store|/nix/store|g' "$f"
    done
  '';
  meta = {
    description = "GXDE launcher";
    homepage = "https://github.com/GXDE-OS/gxde-launcher";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
