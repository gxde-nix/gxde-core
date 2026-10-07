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
  pname = "gxde-app-upgrader";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-app-upgrader";
    rev = "2c88f619e9b69720f8e16e7324db48f9cdd47194";
    hash = "sha256-qqiieFvzU8xZrNAlbFGpQuvNWfRFGQT59qHntRLX8nM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dpm0755 src/usr/bin/gxde-app-upgrader $out/bin/gxde-app-upgrader
    install -Dpm0755 ${./files/gxde-app-upgrader/gxde-do-upgrade-fedora} \
      $out/libexec/gxde-app-upgrader/gxde-do-upgrade.sh
    install -Dpm0755 ${./files/gxde-app-upgrader/gxde-do-upgrade-worker-fedora} \
      $out/libexec/gxde-app-upgrader/gxde-do-upgrade-worker.sh
    install -Dpm0755 ${./files/gxde-app-upgrader/gxde-update-notifier-fedora} \
      $out/libexec/gxde-app-upgrader/gxde-update-notifier.sh
    install -Dpm0644 ${./files/gxde-app-upgrader/gxde-update-notifier.service} \
      $out/lib/systemd/user/gxde-update-notifier.service
    install -Dpm0644 ${./files/gxde-app-upgrader/gxde-update-notifier.timer} \
      $out/lib/systemd/user/gxde-update-notifier.timer
    install -Dpm0644 src/usr/share/polkit-1/actions/org.gxde.gxde-app-upgrader.policy \
      $out/share/polkit-1/actions/org.gxde.gxde-app-upgrader.policy

    for f in $out/bin/gxde-app-upgrader $out/libexec/gxde-app-upgrader/*.sh; do
      patchShebangs "$f"
      wrapProgram "$f" \
        --prefix PATH : ${lib.makeBinPath [ bash garma polkit zenity libnotify transhell ]} \
        --prefix XDG_DATA_DIRS : $out/share
    done

    runHook postInstall
  '';

  meta = {
    description = "GXDE application upgrader";
    homepage = "https://github.com/GXDE-OS/gxde-app-upgrader";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gxde-app-upgrader";
  };
})
