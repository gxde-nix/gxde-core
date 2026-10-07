{
  lib,
  buildFHSEnv,
  gxde-core,
  gxde-desktop-schemas,
  kwin-no-scale,
}:

buildFHSEnv {
  name = "gxde-session";

  targetPkgs = pkgs: [
    gxde-core
    gxde-desktop-schemas
    kwin-no-scale
    pkgs.dbus
    pkgs.dconf
    pkgs.glib
    pkgs.gnome-keyring
    pkgs.libcgroup
    pkgs.linux-pam
    pkgs.pulseaudio
    pkgs.systemd
    pkgs.util-linux
    pkgs.xrdb
    pkgs.xset
  ];

  extraBuildCommands = ''
    mkdir -p $out/etc/pam.d
    cat > $out/etc/pam.d/system-auth <<EOF
    auth       required   pam_unix.so nullok
    account    required   pam_unix.so
    password   required   pam_unix.so nullok sha512 shadow
    session    required   pam_unix.so
    EOF
  '';

  runScript = "startgxde";

  extraInstallCommands = ''
    mkdir -p $out/share/xsessions
    cat > $out/share/xsessions/gxde.desktop <<EOF
    [Desktop Entry]
    Name=GXDE
    Comment=GX Desktop Environment
    Exec=$out/bin/gxde-session
    TryExec=$out/bin/gxde-session
    Type=Application
    DesktopNames=GXDE
    EOF
  '';

  meta = {
    description = "GXDE desktop session started inside an FHS environment";
    homepage = "https://github.com/GXDE-OS/startgxde";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
