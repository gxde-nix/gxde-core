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
  pname = "kcoreaddons-kf5";
  version = "5.116.0";
  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kcoreaddons";
    rev = "v5.116.0";
    hash = "sha256-I8eqyRDWVdj71SJ9OQTTNNedQyZM8BTmXHOOQS0czWg=";
  };
  outputs = [ "out" "dev" ];
  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake pkg-config ecm ];
  buildInputs = [ qt5.qtbase qt5.qttools ];
  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTING" false) (lib.cmakeBool "BUILD_QCH" false) ];
  meta = {
    description = "KDE Frameworks 5 kcoreaddons (for gxde-globalmenu-service)";
    homepage = "https://invent.kde.org/frameworks/kcoreaddons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
