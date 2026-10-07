{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsysprof-capture,
  qt6,
  gsettings-qt6,
  libxcb,
  libX11,
  libXext,
  libXtst,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6widget,
  dtk6log,
  dframework-dbus-qt6,
  gxde-network-utils-qt6,
  libdbusmenu-qt6,
  gxde-desktop-schemas,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-top-panel-plugins";
  version = "6.1.1";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-top-panel-plugins";
    rev = "d906ed40bff6faa357109f60c459e83af8a223a3";
    hash = "sha256-vW3e7t5e9WD3IgLeP6cCODwtY2MibqDD+ajc5KJInlI=";
  };
  dontWrapQtApps = true;
  patches = [
    ./patches/gxde-top-panel-plugins/0001-use-fedora-qt6-tools.patch
    ./patches/gxde-top-panel-plugins/0002-use-gxde-dbusmenu-qt6.patch
  ];
  postPatch = ''
    find . -name CMakeLists.txt -print0 | while IFS= read -r -d "" f; do
      sed -i -E 's#DESTINATION /usr/#DESTINATION #g; s#DESTINATION /etc/#DESTINATION etc/#g' "$f"
    done

    for f in $(find . -name 'translate_generation.sh'); do
      substituteInPlace "$f" --replace-fail '/usr/lib64/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease'
    done
  '';

  preConfigure = ''
    mkdir -p .pcfix/pkgconfig .pcfix/cmake

    for f in ${libdbusmenu-qt6}/lib/pkgconfig/*.pc ${libdbusmenu-qt6.dev}/lib/pkgconfig/*.pc; do
      [ -e "$f" ] || continue
      base=$(basename "$f")
      sed -E -e "s|^prefix=.*|prefix=${libdbusmenu-qt6.dev}|" \
             -e "s|^exec_prefix=.*|exec_prefix=${libdbusmenu-qt6.dev}|" \
             -e "s|[^ \"']*-libdbusmenu-qt6[^/]*/include|${libdbusmenu-qt6.dev}/include|g" \
        "$f" > .pcfix/pkgconfig/"$base"
    done

    for f in ${libdbusmenu-qt6}/lib/cmake/*/*.cmake ${libdbusmenu-qt6.dev}/lib/cmake/*/*.cmake; do
      [ -e "$f" ] || continue
      sed -E "s|[^ \"']*-libdbusmenu-qt6[^/]*/include|${libdbusmenu-qt6.dev}/include|g" \
        "$f" > .pcfix/cmake/"$(basename "$f")"
    done

    merged=$PWD/.dbusmenu-merged
    mkdir -p $merged
    for d in ${libdbusmenu-qt6} ${libdbusmenu-qt6.dev}; do
      for e in "$d"/*; do
        [ -e "$e" ] || continue
        ln -sfn "$e" "$merged/$(basename "$e")"
      done
    done

    export PKG_CONFIG_PATH="$PWD/.pcfix/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
    export PKG_CONFIG_PATH=$(echo "$PKG_CONFIG_PATH" | tr ':' '\n' | grep -v 'gxde-infras' | paste -sd:)
    export CMAKE_PREFIX_PATH="$merged:$PWD/.pcfix/cmake''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
    export CMAKE_PREFIX_PATH=$(echo "$CMAKE_PREFIX_PATH" | tr ':' '\n' | grep -v 'gxde-infras' | paste -sd:)
  '';

  nativeBuildInputs = [ cmake pkg-config libsysprof-capture qt6.qttools ];


  cmakeFlags = [ (lib.cmakeFeature "dbusmenu-qt6_DIR" "${libdbusmenu-qt6.dev}/lib/cmake/dbusmenu-qt6") ];
  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    gsettings-qt6
    libxcb
    libX11
    libXext
    libXtst
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6widget
    dtk6log
    dframework-dbus-qt6
    gxde-network-utils-qt6
    libdbusmenu-qt6
    gxde-desktop-schemas
  ];
  meta = {
    description = "GXDE top panel plugins";
    homepage = "https://github.com/GXDE-OS/gxde-top-panel-plugins";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
