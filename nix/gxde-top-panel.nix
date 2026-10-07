{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  gsettings-qt6,
  kdePackages,
  libxcb,
  libX11,
  libxdo,
  dtk6core,
  dtk6gui,
  dtk6widget,
  dtk6log,
  dframework-dbus-qt6,
  gxde-top-panel-plugins,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-top-panel";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-top-panel";
    rev = "4cfc6f95e7b07f1940146d4def77856159e25074";
    hash = "sha256-Npc/ZRkfBn5UDrJtI0rv+IMICCrBGNY/ucd6QU6DPMA=";
  };
  dontWrapQtApps = true;
  patches = [ ./patches/gxde-top-panel/0001-fix-fedora-install-paths.patch ];
  nativeBuildInputs = [ cmake pkg-config qt6.qttools ];
  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    gsettings-qt6
    kdePackages.kwindowsystem
    kdePackages.layer-shell-qt
    libxcb
    libX11
    libxdo
    dtk6core
    dtk6gui
    dtk6widget
    dtk6log
    dframework-dbus-qt6
    gxde-top-panel-plugins
  ];
  cmakeFlags = [ (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true) ];

  postInstall = ''
    for f in $out/lib/pkgconfig/*.pc $out/share/pkgconfig/*.pc; do
      [ -e "$f" ] || continue
      sed -i 's|//nix/store|/nix/store|g' "$f"
    done
  '';
  meta = {
    description = "GXDE top panel";
    homepage = "https://github.com/GXDE-OS/gxde-top-panel";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
