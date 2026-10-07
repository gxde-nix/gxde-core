{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-account-faces";
  version = "1.0.12.2";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-account-faces";
    rev = "de8b351c009222606af69b7369c8acf28b98f1f3";
    hash = "sha256-5JAzZIZU/o93QkHVO4fNdXS5vy1LFn985tbNkgS1Uoo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/var/lib/AccountsService
    cp -a icons $out/var/lib/AccountsService/
    chmod 0775 $out/var/lib/AccountsService/icons

    runHook postInstall
  '';

  meta = {
    description = "Default account icons for GXDE (AccountsService)";
    homepage = "https://github.com/GXDE-OS/gxde-account-faces";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
