{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  gsettings-qt6,
  glib,
  libxcrypt,
  fontconfig,
  freetype,
  libnm,
  mtdev,
  wayland,
  libxcb,
  libX11,
  libXext,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6log,
  dframework-dbus-qt6,
  gxde-network-utils-qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-control-center";
  version = "6.0.24";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-control-center";
    rev = "c402db8178cb499562e30bb69176b2d8d5fecd7c";
    hash = "sha256-81s71P6XCavccBt2XuI1uG44JS3/27AXeCQ9mNHPNJQ=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake pkg-config qt6.qttools ];
  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    kdePackages.layer-shell-qt
    kdePackages.networkmanager-qt
    gsettings-qt6
    glib
    libxcrypt
    fontconfig
    freetype
    libnm
    mtdev
    wayland
    libxcb
    libX11
    libXext
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6log
    dframework-dbus-qt6
    gxde-network-utils-qt6
  ];
  postPatch = ''
    find . -name CMakeLists.txt -print0 | while IFS= read -r -d "" f; do
      sed -i -E 's#DESTINATION /usr/#DESTINATION #g; s#DESTINATION /etc/#DESTINATION etc/#g' "$f"
    done

    for f in $(find . -name 'translate_generation.sh'); do
      substituteInPlace "$f" \
        --replace '/usr/lib/qt6/bin/lupdate' '${qt6.qttools}/bin/lupdate' \
        --replace '/usr/lib/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease' \
        --replace '/usr/lib64/qt6/bin/lupdate' '${qt6.qttools}/bin/lupdate' \
        --replace '/usr/lib64/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease'
    done
  '';
  cmakeFlags = [ (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true) ];
  postInstall = ''
    for f in $out/lib/pkgconfig/*.pc $out/share/pkgconfig/*.pc; do
      [ -e "$f" ] || continue
      sed -i 's|//nix/store|/nix/store|g' "$f"
    done
  '';
  meta = {
    description = "GXDE control center";
    homepage = "https://github.com/GXDE-OS/gxde-control-center";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
