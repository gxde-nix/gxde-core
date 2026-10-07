{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  ecm,
  libxcb,
  xorg,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kwindowsystem-kf5";
  version = "5.116.0";
  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kwindowsystem";
    rev = "v5.116.0";
    hash = "sha256-Cu1re0/Cr2rEptJ5D+Ihp/fkh9hJhXOSGVniUGDewck=";
  };
  outputs = [ "out" "dev" ];
  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake pkg-config ecm ];
  buildInputs = [
    qt5.qtbase
    qt5.qtx11extras
    qt5.qttools
    libxcb
    xorg.libX11
    xorg.libXfixes
  ];
  cmakeFlags = [
    (lib.cmakeBool "BUILD_QCH" false)
    (lib.cmakeBool "BUILD_TESTING" false)
  ];
  meta = {
    description = "KDE Frameworks 5 window system library (last KF5 release, built for gxde-globalmenu-service)";
    homepage = "https://invent.kde.org/frameworks/kwindowsystem";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
