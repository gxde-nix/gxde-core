{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  ecm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kconfig-kf5";
  version = "5.116.0";
  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kconfig";
    rev = "v5.116.0";
    hash = "sha256-zNRTSaf4nr+6Hj1fBdKPtfEgoS+/pXzxEMsuxmNsuXs=";
  };
  outputs = [ "out" "dev" ];
  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake pkg-config ecm ];
  buildInputs = [ qt5.qtbase qt5.qttools ];
  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTING" false) (lib.cmakeBool "BUILD_QCH" false) ];
  meta = {
    description = "KDE Frameworks 5 kconfig (for gxde-globalmenu-service)";
    homepage = "https://invent.kde.org/frameworks/kconfig";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
