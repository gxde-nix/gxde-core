{
  lib,
  stdenv,
  fetchFromGitHub,
  gxde-app-installer,
  gxde-app-upgrader,
  gxde-app-uninstaller,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-shell-tools";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-shell-tools";
    rev = "4572768cef24160144a5e1c140709aa0f5bb41e5";
    hash = "sha256-Cm/Tv0HtpIQQDATFVEqQNVXWng8e7HUtPKdIHHJyd7Q=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dpm0644 README.md $out/share/doc/gxde-shell-tools/README.md
    runHook postInstall
  '';

  propagatedBuildInputs = [
    gxde-app-installer
    gxde-app-upgrader
    gxde-app-uninstaller
  ];

  meta = {
    description = "Meta package for the GXDE application installer, upgrader and uninstaller";
    homepage = "https://github.com/GXDE-OS/gxde-shell-tools";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
