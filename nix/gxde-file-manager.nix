{
  lib,
  stdenv,
  writeText,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  gsettings-qt6,
  libsysprof-capture,
  libgcrypt,
  libgpg-error,
  libisoburn,
  glib,
  file,
  mtdev,
  wayland,
  libxcb,
  libxcb-wm,
  libX11,
  jemalloc,
  libsecret,
  poppler,
  ffmpegthumbnailer,
  taglib,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6widget,
  dframework-dbus-qt6,
  udisks2-qt6,
  disomaster-qt6,
  gxde-movie-reborn-qt6,
  gxde-dock,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-file-manager";
  version = "6.4.10";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-file-manager";
    rev = "ca3f2d3172b238a1d80d3fc8e21b8d3c9213b161";
    hash = "sha256-C1gfDpf5CE5Ri3mBbClKldTaIwvaiQ91AaGEtY0Z6sY=";
  };
  dontWrapQtApps = true;

  env.NIX_CFLAGS_COMPILE = "-std=gnu++20 -I${dtk6core.dev}/include/dtk6 -I${dtk6gui.dev}/include/dtk6 -I${dtk6core.dev}/include/dtk6/DCore -I${dtk2widget-qt6.dev}/include/dtk2/DWidget -I${dtk6widget.dev}/include/dtk6/DWidget -I${dtk6gui.dev}/include/dtk6/DGui -I${kdePackages.kcodecs.dev}/include/KF6 -I${kdePackages.kcodecs.dev}/include/KF6/KCodecs";
  env.NIX_LDFLAGS = "-lLayerShellQtInterface -ldtk6gui -ldtk6core";
  patches = [ ./patches/gxde-file-manager/0002-deterministic-git-version.patch ];
  nativeBuildInputs = [ cmake pkg-config libsysprof-capture libgcrypt qt6.qttools ];
  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    qt6.qt5compat
    qt6.qtscxml
    kdePackages.kcodecs
    kdePackages.layer-shell-qt
    kdePackages.polkit-qt-1
    gsettings-qt6
    glib
    libsysprof-capture
    libgcrypt
    libgpg-error
    libisoburn
    file
    mtdev
    wayland
    libxcb
    libxcb-wm
    libX11
    jemalloc
    libsecret
    poppler
    ffmpegthumbnailer
    taglib
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6widget
    dframework-dbus-qt6
    udisks2-qt6
    disomaster-qt6
    gxde-movie-reborn-qt6
    gxde-dock
  ];
  preConfigure = ''
    if [ ! -e gxde-file-manager/gxde-file-manager-dialog-autostart.desktop ]; then
      mkdir -p gxde-file-manager
      cat > gxde-file-manager/gxde-file-manager-dialog-autostart.desktop <<'DESK'
[Desktop Entry]
Type=Application
Name=GXDE File Manager
Exec=gxde-file-manager
NoDisplay=true
DESK
    fi

    sed -i 's|set(CMAKE_INSTALL_PREFIX "/usr" CACHE PATH "" FORCE)|set(CMAKE_INSTALL_PREFIX "''${CMAKE_INSTALL_PREFIX}" CACHE PATH "" FORCE)|' cmake/GXDECommon.cmake 2>/dev/null || true

    [ -e gxde-file-manager-lib/configure/default-view-states.json ] || \
      echo '{}' > gxde-file-manager-lib/configure/default-view-states.json

    echo 'target_sources(gxde-desktop-panel PRIVATE ''${CMAKE_CURRENT_SOURCE_DIR}/util/wayland/layershellhelper.cpp)' >> gxde-desktop-panel/CMakeLists.txt

    {
      echo 'file(GLOB dbus_gen_files ''${CMAKE_SOURCE_DIR}/dbus-gen/com_deepin_wm.cpp)'
      echo 'target_sources(gxde-desktop-panel PRIVATE ''${dbus_gen_files})'
    } >> gxde-desktop-panel/CMakeLists.txt

    sed -i '0,/^)$/s|^)$|)\ninclude_directories(''${CMAKE_SOURCE_DIR}/dbus-gen)|' CMakeLists.txt

    for f in $(grep -rl '/usr/include/gxde-dock' --include=CMakeLists.txt .); do
      sed -i "s|/usr/include/gxde-dock|${gxde-dock}/include/gxde-dock|g" "$f"
    done

    for f in $(grep -rlE 'DDesktopServices|DWindowManagerHelper|DImageButton|DTK_WIDGET_NAMESPACE' --include=CMakeLists.txt .); do
      grep -q 'find_package(Dtk6' "$f" || sed -i '0,/^)$/s|^)$|)\nfind_package(Dtk6 REQUIRED COMPONENTS Core Gui Widget)|' "$f"
    done

    for f in $(grep -rl 'GuiPrivate' --include=CMakeLists.txt .); do
      grep -q 'Qt6GuiPrivate' "$f" && continue
      if grep -q '^project(' "$f"; then
        sed -i '0,/^project(/s//&\nfind_package(Qt6GuiPrivate REQUIRED)/' "$f"
      else
        sed -i '1i find_package(Qt6GuiPrivate REQUIRED)' "$f"
      fi
    done

    mkdir -p dbus-gen
    for x in $(find . -name '*.xml' -path '*dbus*'); do
      qdbusxml2cpp -p "dbus-gen/$(basename "$x" .xml | tr '.' '_')" "$x" 2>/dev/null || true
    done
    cp gxde-wallpaper-chooser/dbus/com.deepin.wm.xml wm-augmented.xml
    python3 - <<'PYEOF'
import pathlib
p = pathlib.Path('wm-augmented.xml')
t = p.read_text()
sig = '  <signal name="WorkspaceSwitched">\n    <arg type="i" name="from"/>\n    <arg type="i" name="to"/>\n  </signal>\n'
m1 = '  <method name="GetCurrentWorkspaceBackground">\n    <arg type="s" name="background" direction="out"/>\n  </method>\n'
p.write_text(t.replace('</interface>', sig + m1 + '</interface>'))
PYEOF
    qdbusxml2cpp -p dbus-gen/com_deepin_wm wm-augmented.xml 2>/dev/null || true

    mkdir -p pkgconfig-alias
    cat > pkgconfig-alias/dframeworkdbus-qt6.pc <<PC
prefix=${dframework-dbus-qt6.dev}
libdir=${dframework-dbus-qt6}/lib
includedir=${dframework-dbus-qt6.dev}/include/libdframeworkdbus-qt6-6.0

Name: dframeworkdbus-qt6
Description: DFramework DBus for Qt6
Version: 6.0.1
Libs: -L''${libdir} -ldframeworkdbus-qt6
Cflags: -I''${includedir}
Requires: Qt6Core Qt6DBus Qt6Xml
PC
    export PKG_CONFIG_PATH="$PWD/pkgconfig-alias''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  '';


  postPatch = ''
    find . -name CMakeLists.txt -print0 | xargs -0 sed -i -z -E \
      's#DESTINATION[[:space:]]+/usr/#DESTINATION #g; s#DESTINATION[[:space:]]+/etc/#DESTINATION etc/#g'

    for f in $(grep -rl 'dde-ofd-preview-plugin' --include=CMakeLists.txt .); do
      sed -i '/dde-ofd-preview-plugin/d' "$f"
    done

    for f in $(grep -rl 'Qt6::GuiPrivate' --include=CMakeLists.txt .); do
      sed -i '0,/find_package(Qt6[^)]*)/s//&\nfind_package(Qt6GuiPrivate REQUIRED)/' "$f"
    done

    for f in $(grep -rl 'add_subdirectory(ofd)' --include=CMakeLists.txt .); do
      sed -i '/add_subdirectory(ofd)/d' "$f"
    done

    for f in $(grep -rl 'dframeworkdbus' --include=CMakeLists.txt .); do
      sed -i 's/dframeworkdbus-qt6/dframeworkdbus-qt6/g; s/\bdframeworkdbus\b/dframeworkdbus-qt6/g' "$f"
    done
  '';
  cmakeFlags = [
    (lib.cmakeFeature "GIT_VERSION" "ca3f2d3172b238a1d80d3fc8e21b8d3c9213b161")
    (lib.cmakeFeature "Qt6GuiPrivate_DIR" "${qt6.qtbase}/lib/cmake/Qt6GuiPrivate")
    (lib.cmakeBool "GXDE_DISABLE_ANYTHING" true)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "libexec")
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" "share")
    (lib.cmakeFeature "CMAKE_INSTALL_SYSCONFDIR" "etc")
    (lib.cmakeFeature "CMAKE_INSTALL_LOCALSTATEDIR" "var")
    (lib.cmakeBool "BUILD_MINIMUM" false)
    (lib.cmakeBool "DISABLE_FFMPEG" false)
    (lib.cmakeBool "DISABLE_JEMALLOC" false)
  ];
  preInstall = ''
    echo '=== install rule 110-125 ==='
    find . -name cmake_install.cmake -print0 | xargs -0 sed -i -E \
      's#"/usr/#"#g; s#"/etc/#"etc/#g; s#"/var/#"var/#g'
  '';

  postInstall = ''
    for f in $out/lib/pkgconfig/*.pc $out/share/pkgconfig/*.pc; do
      [ -e "$f" ] || continue
      sed -i 's|//nix/store|/nix/store|g' "$f"
    done
  '';
  meta = {
    description = "GXDE file manager";
    homepage = "https://github.com/GXDE-OS/gxde-file-manager";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
