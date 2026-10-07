{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libdrm,
  libxkbcommon,
  pixman,
  libinput,
  systemdLibs,
  seatd,
  hwdata,
  libdisplay-info,
  libGL,
  xorg,
  libxcb,
  libxcb-errors,
  libgbm,
  xwayland,
  vulkan-loader,
  vulkan-headers,
  glslang,
  libxcb-render-util,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-util,
  libxcb-cursor,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "open-kylin-wlroots";
  version = "0.17.4-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "open-kylin-wlroots";
    rev = "950dbeb6cc3701832b3623fdd4bc51c9a9a37f6e";
    hash = "sha256-CVrH7mZbdbPCEmc3vwipMCj+Misw6ljizO5STWLYjlU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libdrm
    libxkbcommon
    pixman
    libinput
    systemdLibs
    seatd
    hwdata
    libdisplay-info
    libGL
    xorg.libxcb
    xorg.libX11
    libxcb-errors
    libgbm
    xwayland
    vulkan-loader
    vulkan-headers
    glslang
    libxcb-render-util
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-util
    libxcb-cursor
  ];

  mesonFlags = [
    "--default-library=static"
    "--libdir=${placeholder "out"}/lib/gxde/wlroots"
    "--includedir=${placeholder "out"}/include/gxde/wlroots"
    "-Dexamples=false"
    "-Dxwayland=enabled"
    "-Dsession=enabled"
    "-Dbackends=drm,libinput,x11"
    "-Drenderers=gles2,vulkan"
    "-Dxcb-errors=enabled"
  ];

  meta = {
    description = "wlroots fork used by the GXDE compositor";
    homepage = "https://github.com/GXDE-OS/open-kylin-wlroots";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
