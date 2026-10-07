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
  libnotify,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-app-uninstaller";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-app-uninstaller";
    rev = "a65404a59c993a75ee94928f8e61e5639a031709";
    hash = "sha256-LNY2lfI+TC1xavP1OAB1VGBXmkIyX7o/1THXGQHhpmQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dpm0755 src/usr/bin/gxde-app-uninstaller $out/bin/gxde-app-uninstaller
    install -Dpm0755 ${./files/gxde-app-uninstaller/gxde-app-uninstaller-fedora} \
      $out/libexec/gxde-app-uninstaller/gxde-app-uninstaller
    install -Dpm0755 ${./files/gxde-app-uninstaller/gxde-app-uninstaller-worker-fedora} \
      $out/libexec/gxde-app-uninstaller/gxde-app-uninstaller-worker

    mkdir -p $out/share
    cp -a src/usr/share/gxde-app-uninstaller $out/share/

    install -Dpm0644 src/usr/share/polkit-1/actions/store.spark-app.gxde-app-uninstaller.policy \
      $out/share/polkit-1/actions/store.spark-app.gxde-app-uninstaller.policy

    for f in $out/bin/gxde-app-uninstaller $out/libexec/gxde-app-uninstaller/gxde-app-uninstaller \
             $out/libexec/gxde-app-uninstaller/gxde-app-uninstaller-worker; do
      patchShebangs "$f"
      wrapProgram "$f" \
        --prefix PATH : ${lib.makeBinPath [ bash garma polkit zenity libnotify transhell ]} \
        --prefix XDG_DATA_DIRS : $out/share
    done

    runHook postInstall
  '';

  meta = {
    description = "GXDE application uninstaller";
    homepage = "https://github.com/GXDE-OS/gxde-app-uninstaller";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gxde-app-uninstaller";
  };
})
