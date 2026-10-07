{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  qt6,
  kdePackages,
  dtk2widget-qt6,
  dtk6core,
  dtk6gui,
  dtk6log,
  gxde-k9,
  xdotool,
  xprop,
  xset,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-requ";
  version = "1.4.5";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-requ";
    rev = "2996c03eac3a3c48b68d4f577603dde1dd7dec37";
    hash = "sha256-/4sA2Qq929TQKQMaZOY0p22szTbx7LZWT4HGrds5epI=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake pkg-config makeWrapper qt6.qttools ];
  buildInputs = [
    qt6.qtbase
    kdePackages.layer-shell-qt
    dtk2widget-qt6
    dtk6core
    dtk6gui
    dtk6log
  ];
  postInstall = ''
    wrapProgram $out/bin/gxde-requ \
      --prefix PATH : ${lib.makeBinPath [ gxde-k9 xdotool xprop xset ]}
  '';
  meta = {
    description = "GXDE hot corners";
    homepage = "https://github.com/GXDE-OS/gxde-requ";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
