{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "extra-cmake-modules-kf5";
  version = "5.116.0";
  src = fetchFromGitHub {
    owner = "KDE";
    repo = "extra-cmake-modules";
    rev = "v5.116.0";
    hash = "sha256-wdjwWHLpyXNhQPGJh/q6QxnO0NJt3aRbluxG/CQol4w=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ qt5.qtbase ];
  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTING" false) ];
  meta = {
    description = "KDE Frameworks 5 extra CMake modules (needed to build the KF5 kwindowsystem)";
    homepage = "https://invent.kde.org/frameworks/extra-cmake-modules";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
