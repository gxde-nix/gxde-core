{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  qt6,
  kdePackages,
  gsettings-qt6,
  qt6NoHook,
  gsettings-qt,
  lightdm_qt,
  accountsservice,
  linux-pam,
  systemdLibs,
  libX11,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXtst,
  libXcursor,
  libxcb-wm,
  libxdmcp,
  libsysprof-capture,
  util-linux,
  libselinux,
  libsepol,
  libXau,
  dtk5core,
  dtk5widget,
  dtk2widget,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6log,
  dtk6widget,
  dframework-dbus-qt6,
  dde-qt-dbus-factory,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-session-ui";
  version = "5.1.6";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-session-ui";
    rev = "76039e86b769e54c2dd527652418405a6020d29f";
    hash = "sha256-kbUGm5wd0WhGUT9bCuz4+vNrii4MNnVIHlWgOJcX31k=";
  };
  dontWrapQtApps = true;

  env.CMAKE_PREFIX_PATH = lib.concatStringsSep ":" [ qt6.qtbase qt6.qtsvg qt6.qttools qt6.qtdeclarative dtk2widget-qt6 dtk6core.dev dtk6gui.dev dtk6log.dev dtk6widget.dev dframework-dbus-qt6.dev kdePackages.layer-shell-qt.dev gsettings-qt6.dev ];
  env.NIX_CFLAGS_COMPILE = "-Wno-error -Wno-error=deprecated-declarations -I${gsettings-qt6.dev}/include/qt6";
  patches = [ ./patches/gxde-session-ui/0001-fedora-install-paths.patch ];
  postPatch = ''
    sed -i '/add_subdirectory(dde-osd)/d' CMakeLists.txt
    chmod +x ./*.sh
    patchShebangs .
    for f in translate_generation.sh translate_desktop.sh; do
      [ -e "$f" ] || continue
      substituteInPlace "$f" \
        --replace '/usr/lib64/qt5/bin/lrelease' '${qt5.qttools.dev}/bin/lrelease' \
        --replace '/usr/lib64/qt5/bin/lupdate' '${qt5.qttools.dev}/bin/lupdate' \
        --replace '/usr/lib/qt5/bin/lrelease' '${qt5.qttools.dev}/bin/lrelease' \
        --replace '/usr/lib/qt5/bin/lupdate' '${qt5.qttools.dev}/bin/lupdate' \
        --replace '/usr/lib64/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease' \
        --replace '/usr/lib/qt6/bin/lrelease' '${qt6.qttools}/bin/lrelease'
    done
    find . -name CMakeLists.txt -print0 | xargs -0 sed -i -E \
      's#DESTINATION[[:space:]]+/usr/#DESTINATION #g;
       s#DESTINATION[[:space:]]+/etc/#DESTINATION etc/#g;
       s#DESTINATION[[:space:]]+\$\{PREFIX\}/#DESTINATION #g;
       s#-DSHUTDOWN_INSTALL_PREFIX:PATH=\$\{PREFIX\}#-DSHUTDOWN_INSTALL_PREFIX:PATH=\$\{CMAKE_INSTALL_PREFIX\}#g'
  '';
  nativeBuildInputs = [ cmake pkg-config qt5.qttools ];

  preBuild = ''
    export PATH=${qt6.qttools}/bin:$PATH
  '';
  buildInputs = [
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    qt5.qtx11extras
    gsettings-qt
    lightdm_qt
    accountsservice
    linux-pam
    systemdLibs
    libX11
    libXext
    libXfixes
    libXi
    libXrandr
    libXtst
    libXcursor
    libxcb-wm
    libxdmcp
    libsysprof-capture
    util-linux
    libselinux
    libsepol
    libXau
    dtk5core
    dtk5widget
    dtk2widget
    dde-qt-dbus-factory
    gsettings-qt6
    dframework-dbus-qt6
    qt6NoHook
    dtk2widget-qt6
  ];
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeFeature "QT6_CMAKE_DIR" "${qt6.qtbase}/lib/cmake/Qt6")
  ];
  meta = {
    description = "GXDE session UI (lock screen, greeter, OSD helpers)";
    homepage = "https://github.com/GXDE-OS/gxde-session-ui";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
