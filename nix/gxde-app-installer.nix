{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  transhell,
  garma,
  polkit,
  zenity,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-app-installer";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-app-installer";
    rev = "4b4434044c493c76e0b104d51e84dd955981a3d6";
    hash = "sha256-9KiweEeVeyKRzTcDq+AFFu8Zsdiwfdqa88Pd33pGmy4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dpm0755 src/usr/bin/gxde-app-installer $out/bin/gxde-app-installer
    install -Dpm0755 ${./files/gxde-app-installer/gxde-app-installer-fedora} \
      $out/libexec/gxde-app-installer/gxde-app-installer
    cp -a src/usr/libexec/gxde-app-installer/transhell $out/libexec/gxde-app-installer/
    install -Dpm0644 src/usr/share/polkit-1/actions/top.gxde.gxde-app-installer.policy \
      $out/share/polkit-1/actions/top.gxde.gxde-app-installer.policy

    for f in $out/bin/gxde-app-installer $out/libexec/gxde-app-installer/gxde-app-installer; do
      patchShebangs "$f"
      wrapProgram "$f" \
        --prefix PATH : ${lib.makeBinPath [ bash garma polkit zenity transhell ]} \
        --prefix XDG_DATA_DIRS : $out/share
    done

    runHook postInstall
  '';

  meta = {
    description = "GXDE application installer";
    homepage = "https://github.com/GXDE-OS/gxde-app-installer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gxde-app-installer";
  };
})
