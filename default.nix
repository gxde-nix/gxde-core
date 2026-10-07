{ pkgs, dtk5, dtk6, dtk2, infras }:

let
  inherit (pkgs) lib;

  gxde-api = infras.gxde-api;
  gxde-k9 = infras.gxde-k9;
  gxde-movie-reborn = infras.gxde-movie-reborn;
  dframework-dbus-qt6 = fixQt6Paths infras.dframework-dbus-qt6;
  gxde-network-utils-qt6 = fixQt6Paths infras.gxde-network-utils-qt6;
  fixQt6Paths = pkg: pkg.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      for f in $out/lib/pkgconfig/*.pc $dev/lib/pkgconfig/*.pc; do
        [ -e "$f" ] || continue
        sub=$(basename "$(grep -m1 '^includedir=' "$f" | cut -d= -f2-)")
        sed -i -E \
          -e "s|^prefix=.*|prefix=$dev|" \
          -e "s|^exec_prefix=.*|exec_prefix=$dev|" \
          -e "s|^includedir=.*|includedir=$dev/include/$sub|" \
          "$f"
      done
      for f in $out/lib/cmake/*/*.cmake $dev/lib/cmake/*/*.cmake; do
        [ -e "$f" ] || continue
        sed -i -e 's#''${PACKAGE_PREFIX_DIR}/include#${placeholder "dev"}/include#g' \
               -e 's#''${_IMPORT_PREFIX}/include#${placeholder "dev"}/include#g' "$f"
      done
    '';
  });

  libdbusmenu-qt6 = fixQt6Paths infras.libdbusmenu-qt6;

  udisks2-qt6 = fixQt6Paths infras.udisks2-qt6;

  disomaster-qt6 = fixQt6Paths infras.disomaster-qt6;

  gxde-desktop-schemas = infras.gxde-desktop-schemas;
  gsettings-qt6 = pkgs.lomiri-qt6.gsettings-qt;
  libnm = pkgs.networkmanager;
  dde-qt-dbus-factory = dtk2.dde-qt-dbus-factory;
  golang-gxde-dev = infras.golang-gxde-dev;
  libgnome-keyring = infras.libgnome-keyring;
  dtk2widget-qt6 = dtk2.dtk2widget-qt6;
  qt6NoHook = pkgs.qt6.qtbase.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      rm -f $out/nix-support/setup-hook $dev/nix-support/setup-hook
    '';
  });

  dtk5core = dtk5.dtk5core;
  dtk5widget = dtk5.dtk5widget;
  dtk2widget = dtk2.dtk2widget;
  libxdo = pkgs.xdotool;
  dtk6core = dtk6.dtk6core.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      if [ -d $out/libexec/dtk6/DCore/bin ] && [ ! -e $dev/libexec/dtk6/DCore/bin/deepin-os-release ]; then
        mkdir -p $dev/libexec/dtk6/DCore/bin
        cp -a $out/libexec/dtk6/DCore/bin/. $dev/libexec/dtk6/DCore/bin/
      fi
    '';
  });
  dtk6gui = dtk6.dtk6gui;
  dtk6log = dtk6.dtk6log;
  dtk6widget = dtk6.dtk6widget;

  transhell = pkgs.callPackage ./nix/transhell.nix { };

  zipu = pkgs.callPackage ./nix/zipu.nix { };

  gxde-icon-theme = pkgs.callPackage ./nix/gxde-icon-theme.nix { };

  deepin-gtk-theme = pkgs.callPackage ./nix/deepin-gtk-theme.nix { };

  gxde-sound-theme = pkgs.callPackage ./nix/gxde-sound-theme.nix { };

  gxde-account-faces = pkgs.callPackage ./nix/gxde-account-faces.nix { };

  gxde-artwork = pkgs.callPackage ./nix/gxde-artwork.nix {
    inherit deepin-gtk-theme gxde-icon-theme;
  };

  gxde-wallpapers = pkgs.callPackage ./nix/gxde-wallpapers.nix {
    inherit gxde-api;
  };

  deepin-installer-reborn = pkgs.callPackage ./nix/deepin-installer-reborn.nix { };

  deepin-menu = pkgs.callPackage ./nix/deepin-menu.nix {
    inherit dtk2widget-qt6 dtk6core dtk6gui dtk6log;
  };

  gxde-sni-server = pkgs.callPackage ./nix/gxde-sni-server.nix { };

  open-kylin-wlroots = pkgs.callPackage ./nix/open-kylin-wlroots.nix { };

  gxde-wlcom = pkgs.callPackage ./nix/gxde-wlcom.nix {
    inherit open-kylin-wlroots;
  };

  dpa-ext-gnomekeyring = pkgs.callPackage ./nix/dpa-ext-gnomekeyring.nix {
    inherit libgnome-keyring;
  };

  gxde-polkit-agent = pkgs.callPackage ./nix/gxde-polkit-agent.nix {
    inherit dpa-ext-gnomekeyring;
    polkit-qt = pkgs.libsForQt5.polkit-qt;
    dde-qt-dbus-factory = dtk2.dde-qt-dbus-factory;
    dtk2core = dtk2.dtk2core;
    dtk2widget = dtk2.dtk2widget;
  };

  deepin-daemon = pkgs.callPackage ./nix/deepin-daemon.nix {
    inherit golang-gxde-dev gxde-api;
  };

  startgxde = pkgs.callPackage ./nix/startgxde.nix {
    inherit golang-gxde-dev gxde-api libgnome-keyring;
  };

  gxde-daemon = pkgs.callPackage ./nix/gxde-daemon.nix {
    inherit gxde-wlcom;
  };

  garma = pkgs.callPackage ./nix/garma.nix {
    inherit dtk2widget-qt6 dtk6core dtk6gui dtk6log;
  };

  gxde-app-installer = pkgs.callPackage ./nix/gxde-app-installer.nix {
    inherit transhell garma;
  };

  gxde-app-upgrader = pkgs.callPackage ./nix/gxde-app-upgrader.nix {
    inherit transhell garma;
  };

  gxde-app-uninstaller = pkgs.callPackage ./nix/gxde-app-uninstaller.nix {
    inherit transhell garma;
  };

  gxde-shell-tools = pkgs.callPackage ./nix/gxde-shell-tools.nix {
    inherit gxde-app-installer gxde-app-upgrader gxde-app-uninstaller;
  };

  gxde-default-settings = pkgs.callPackage ./nix/gxde-default-settings.nix {
    inherit gxde-artwork;
  };

  gxde-shell-compressor = pkgs.callPackage ./nix/gxde-shell-compressor.nix {
    inherit zipu garma;
  };

  gxde-compressor = pkgs.callPackage ./nix/gxde-compressor.nix {
    inherit gxde-shell-compressor;
  };

  gxde-time-screensaver = pkgs.callPackage ./nix/gxde-time-screensaver.nix { };

  gxde-requ = pkgs.callPackage ./nix/gxde-requ.nix {
    inherit dtk2widget-qt6 dtk6core dtk6gui dtk6log gxde-k9;
  };

  gxde-globalmenu-service = pkgs.callPackage ./nix/gxde-globalmenu-service.nix {
    inherit kconfig-kf5 kcoreaddons-kf5;
    kwindowsystem = kwindowsystem-kf5;
  };

  deepin-screensaver = pkgs.callPackage ./nix/deepin-screensaver.nix {
    inherit dtk6core dtk6gui dtk6widget gxde-time-screensaver;
  };

  gxde-top-panel-plugins = pkgs.callPackage ./nix/gxde-top-panel-plugins.nix {
    inherit gsettings-qt6 dtk2widget-qt6 dtk6core dtk6gui dtk6widget dtk6log;
    inherit dframework-dbus-qt6 gxde-network-utils-qt6 libdbusmenu-qt6 gxde-desktop-schemas;
  };

  gxde-top-panel = pkgs.callPackage ./nix/gxde-top-panel.nix {
    inherit gsettings-qt6 dtk6core dtk6gui dtk6widget dtk6log dframework-dbus-qt6;
    inherit gxde-top-panel-plugins libxdo;
  };

  gxde-dock = pkgs.callPackage ./nix/gxde-dock.nix {
    inherit gsettings-qt6 dtk2widget-qt6 dtk6core dtk6gui dtk6widget dtk6log;
    inherit dframework-dbus-qt6 gxde-network-utils-qt6 libdbusmenu-qt6 deepin-menu gxde-sni-server;
  };

  gxde-dock-fixed = gxde-dock.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      for h in $out/include/gxde-dock/pluginsiteminterface.h $dev/include/gxde-dock/pluginsiteminterface.h; do
        [ -e "$h" ] || continue
        grep -q 'Q_DECLARE_INTERFACE(PluginsItemInterface' "$h" || \
          sed -i 's|Q_DECLARE_INTERFACE(PluginsItemFactoryInterface|Q_DECLARE_INTERFACE(PluginsItemInterface, "com.deepin.dock.PluginsItemInterface")\nQ_DECLARE_INTERFACE(PluginsItemFactoryInterface|' "$h"
      done
    '';
  });

  gxde-control-center = pkgs.callPackage ./nix/gxde-control-center.nix {
    inherit gsettings-qt6 dtk2widget-qt6 dtk6core dtk6gui dtk6log dframework-dbus-qt6 gxde-network-utils-qt6 libnm;
  };

  gxde-launcher = pkgs.callPackage ./nix/gxde-launcher.nix {
    inherit gsettings-qt6 dtk2widget-qt6 dtk6core dtk6gui dtk6log dframework-dbus-qt6;
  };

  gxde-file-manager = pkgs.callPackage ./nix/gxde-file-manager.nix {
    inherit gsettings-qt6 dtk2widget-qt6 dtk6core dtk6gui dtk6widget dframework-dbus-qt6;
    inherit udisks2-qt6 disomaster-qt6;
    gxde-dock = gxde-dock-fixed;
    gxde-movie-reborn-qt6 = gxde-movie-reborn;
  };

  gxde-file-manager-integration = pkgs.callPackage ./nix/gxde-file-manager-integration.nix {
    inherit gxde-file-manager;
  };

  gxde-session-ui = pkgs.callPackage ./nix/gxde-session-ui.nix {
    inherit dtk5core dtk5widget dtk2widget dtk2widget-qt6 dde-qt-dbus-factory qt6NoHook dtk6core dtk6gui dtk6log dtk6widget dframework-dbus-qt6 gsettings-qt6;
  };

  dde-osd = pkgs.callPackage ./nix/dde-osd.nix {
    inherit dtk2widget-qt6 dframework-dbus-qt6 gsettings-qt6 dtk6core dtk6log;
  };

  kwin-no-scale = pkgs.callPackage ./nix/kwin-no-scale.nix { };

  extra-cmake-modules-kf5 = pkgs.callPackage ./nix/extra-cmake-modules-kf5.nix { };

  kwindowsystem-kf5 = pkgs.callPackage ./nix/kwindowsystem-kf5.nix {
    ecm = extra-cmake-modules-kf5;
  };

  kconfig-kf5 = pkgs.callPackage ./nix/kconfig-kf5.nix {
    ecm = extra-cmake-modules-kf5;
  };

  kcoreaddons-kf5 = pkgs.callPackage ./nix/kcoreaddons-kf5.nix {
    ecm = extra-cmake-modules-kf5;
  };

  modules = [
    transhell
    zipu
    gxde-icon-theme
    deepin-gtk-theme
    gxde-sound-theme
    gxde-account-faces
    gxde-artwork
    gxde-wallpapers
    deepin-installer-reborn
    deepin-menu
    gxde-sni-server
    open-kylin-wlroots
    gxde-wlcom
    dpa-ext-gnomekeyring
    gxde-polkit-agent
    deepin-daemon
    startgxde
    gxde-daemon
    garma
    gxde-app-installer
    gxde-app-upgrader
    gxde-app-uninstaller
    gxde-shell-tools
    gxde-globalmenu-service
    gxde-default-settings
    gxde-shell-compressor
    gxde-compressor
    gxde-time-screensaver
    gxde-requ
    deepin-screensaver
    gxde-top-panel-plugins
    gxde-top-panel
    gxde-dock
    gxde-file-manager
    gxde-file-manager-integration
    gxde-session-ui
    dde-osd
    gxde-control-center
    gxde-launcher
  ];

  all = pkgs.symlinkJoin {
    name = "gxde-core-${gxde-wallpapers.version}";
    paths = lib.concatMap (p: [ p (lib.getDev p) ]) modules;
  };

  gxde-session = pkgs.callPackage ./nix/gxde-session.nix {
    gxde-core = all;
    inherit gxde-desktop-schemas kwin-no-scale;
  };
in
{
  inherit
    transhell
    zipu
    gxde-icon-theme
    deepin-gtk-theme
    gxde-sound-theme
    gxde-account-faces
    gxde-artwork
    gxde-wallpapers
    deepin-installer-reborn
    deepin-menu
    gxde-sni-server
    open-kylin-wlroots
    gxde-wlcom
    dpa-ext-gnomekeyring
    gxde-polkit-agent
    deepin-daemon
    startgxde
    gxde-daemon
    garma
    gxde-app-installer
    gxde-app-upgrader
    gxde-app-uninstaller
    gxde-shell-tools
    gxde-default-settings
    gxde-shell-compressor
    gxde-compressor
    gxde-time-screensaver
    gxde-requ
    gxde-globalmenu-service
    deepin-screensaver
    gxde-top-panel-plugins
    gxde-top-panel
    gxde-dock
    gxde-control-center
    gxde-launcher
    gxde-file-manager
    gxde-session-ui
    dde-osd
    kwin-no-scale
    gxde-file-manager-integration
    all
    gxde-session
    ;

  gxde-core = all;

  default = all;
}
