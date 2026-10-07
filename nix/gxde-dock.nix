{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsysprof-capture,
  qt6,
  gsettings-qt6,
  kdePackages,
  libxcb,
  libX11,
  libXtst,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6widget,
  dtk6log,
  dframework-dbus-qt6,
  gxde-network-utils-qt6,
  libdbusmenu-qt6,
  deepin-menu,
  gxde-sni-server,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-dock";
  version = "6.0.24";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-dock";
    rev = "64c81263bef9e69cbc969d00377a00262982fee6";
    hash = "sha256-IwaPGMG9Q8UmMSO6+Sv1lbFj4KgepDxusgYQTE5DbGk=";
  };
  dontWrapQtApps = true;

  enableParallelBuilding = false;
  postPatch = ''
    find . -name CMakeLists.txt -print0 | while IFS= read -r -d "" f; do
      sed -i -E 's#DESTINATION /usr/#DESTINATION #g; s#DESTINATION /etc/#DESTINATION etc/#g' "$f"
    done

    for f in $(find . -name 'translate_generation.sh'); do
      substituteInPlace "$f" \
        --replace-fail '/usr/lib/qt6/bin/lupdate' '${qt6.qttools}/bin/lupdate' \
        --replace-fail '/usr/lib/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease'
    done
  '';

  preConfigure = ''
    mkdir -p .pcfix/pkgconfig .pcfix/cmake

    fix_paths() {
      for f in "$1"/lib/pkgconfig/*.pc "$2"/lib/pkgconfig/*.pc; do
        [ -e "$f" ] || continue
        base=$(basename "$f")
        sub=$(basename "$(grep -m1 '^includedir=' "$f" | cut -d= -f2-)")
        sed -e "s#^prefix=.*#prefix=$2#" \
            -e "s#^exec_prefix=.*#exec_prefix=$2#" \
            -e "s#^includedir=.*#includedir=$2/include/$sub#" \
            "$f" > .pcfix/pkgconfig/"$base"
      done
      for f in "$1"/lib/cmake/*/*.cmake "$2"/lib/cmake/*/*.cmake; do
        [ -e "$f" ] || continue
        sed -E "s#[^ \"']*-(libdbusmenu-qt6|gxde-network-utils-qt6)[^/]*/include#$2/include#g" "$f" > .pcfix/cmake/"$(basename "$f")"
      done
    }

    fix_paths "${libdbusmenu-qt6}" "${libdbusmenu-qt6.dev}"
    fix_paths "${gxde-network-utils-qt6}" "${gxde-network-utils-qt6.dev}"

    merged=$PWD/.merged
    mkdir -p $merged
    for d in ${libdbusmenu-qt6} ${libdbusmenu-qt6.dev} ${gxde-network-utils-qt6} ${gxde-network-utils-qt6.dev}; do
      for e in "$d"/*; do
        [ -e "$e" ] || continue
        ln -sfn "$e" "$merged/$(basename "$e")"
      done
    done

    export PKG_CONFIG_PATH="$PWD/.pcfix/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
    export CMAKE_PREFIX_PATH="$merged''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
  '';

  nativeBuildInputs = [ cmake pkg-config libsysprof-capture qt6.qttools ];
  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    gsettings-qt6
    kdePackages.layer-shell-qt
    libxcb
    libX11
    libXtst
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6widget
    dtk6log
    dframework-dbus-qt6
    gxde-network-utils-qt6
    deepin-menu
    gxde-sni-server
  ];
  cmakeFlags = [
    (lib.cmakeBool "WITH_DOC" false)
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
  ];
  meta = {
    description = "GXDE dock";
    homepage = "https://github.com/GXDE-OS/gxde-dock";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
