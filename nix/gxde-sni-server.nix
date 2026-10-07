{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-sni-server";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-sni-server";
    rev = "b4bddd7193708f225cd43535e8b70bc8dfaa5478";
    hash = "sha256-LilrrkXt1kgQ1oPrQi+u7o2euOUwrZU2JnVW24vCuSI=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kdbusaddons
    kdePackages.kstatusnotifieritem
  ];

  meta = {
    description = "GXDE Status Notifier Item server";
    homepage = "https://github.com/GXDE-OS/gxde-sni-server";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
