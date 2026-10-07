{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gettext,
  meson,
  ninja,
  glslang,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  libdrm,
  libinput,
  systemdLibs,
  pixman,
  libxcb,
  libxcb-render-util,
  libxcb-wm,
  libxdmcp,
  libXau,
  json_c,
  cairo,
  pango,
  librsvg,
  libjpeg_turbo,
  libpng,
  glib,
  libepoxy,
  libgbm,
  openssl,
  libunwind,
  libliftoff,
  libglvnd,
  vulkan-loader,
  hwdata,
  libdisplay-info,
  seatd,
  xwayland,
  open-kylin-wlroots,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-wlcom";
  version = "2.3.7-gxde4";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-wlcom";
    rev = "f75991d4ca218dfd37da9adcc515186cf7dd0f0e";
    hash = "sha256-QE/BJGboDbg/5D9MGBeup+3XX2pPNpp6avvad/hat+c=";
  };

  wlrootsSrc = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "open-kylin-wlroots";
    rev = "950dbeb6cc3701832b3623fdd4bc51c9a9a37f6e";
    hash = "sha256-CVrH7mZbdbPCEmc3vwipMCj+Misw6ljizO5STWLYjlU=";
  };

  postPatch = ''
    mkdir -p libs
    ln -s ${finalAttrs.wlrootsSrc} libs/wlroots

    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'DESTINATION /usr/lib/udev/rules.d' 'DESTINATION lib/udev/rules.d' \
      --replace-fail 'DESTINATION /usr/share/wayland-sessions' 'DESTINATION share/wayland-sessions' \
      --replace-fail 'DESTINATION /usr/bin' 'DESTINATION bin' \
      --replace-fail 'DESTINATION /etc/gxde-wlcom' 'DESTINATION etc/gxde-wlcom'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    meson
    ninja
    glslang
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libdrm
    libinput
    systemdLibs
    pixman
    libxcb
    libxcb-render-util
    libxcb-wm
    libxdmcp
    libXau
    libglvnd
    libliftoff
    vulkan-loader
    hwdata
    libdisplay-info
    seatd
    json_c
    cairo
    pango
    librsvg
    libjpeg_turbo
    libpng
    glib
    libepoxy
    libgbm
    openssl
    libunwind
    xwayland
    open-kylin-wlroots
  ];

  env.NIX_CFLAGS_COMPILE = "-D_DEFAULT_SOURCE -D_GNU_SOURCE";

  preConfigure = ''
    export PKG_CONFIG_PATH=${open-kylin-wlroots}/lib/gxde/wlroots/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}
  '';

  postInstall = ''
    for f in $out/lib/pkgconfig/*.pc; do
      [ -e "$f" ] || continue
      sed -i -E 's|^prefix=.*|prefix=|; s|\$\{prefix\}/|/|g' "$f"
    done
  '';

  cmakeFlags = [
    (lib.cmakeBool "WLCOM_EXAMPLES" false)
    (lib.cmakeFeature "WLCOM_PLUGIN_DIRECTORY" "${placeholder "out"}/lib/gxde-wlcom/plugins")
    (lib.cmakeFeature "WLCOM_LIBUNWIND" "enabled")
    (lib.cmakeFeature "WLCOM_NLS" "enabled")
  ];

  meta = {
    description = "GXDE Wayland compositor";
    homepage = "https://github.com/GXDE-OS/gxde-wlcom";
    license = with lib.licenses; [ gpl3Plus mit bsd3 ];
    platforms = lib.platforms.linux;
  };
})
