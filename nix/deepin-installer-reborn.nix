{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "deepin-installer-timezones";
  version = "2.7.23";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "deepin-installer-reborn";
    rev = "819c934e262c16472ba00addcf4c22d7359c4f70";
    hash = "sha256-z5sodZMMf+mTMqDvTGO/BT/5b/NU3eDgiaaWfPoLaDo=";
  };

  nativeBuildInputs = [ gettext ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    for po in src/third_party/timezones/*/deepin-installer-timezones.po; do
      msgfmt --check-format "$po" -o "''${po%.po}.mo"
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    for mo in src/third_party/timezones/*/deepin-installer-timezones.mo; do
      locale=$(basename "$(dirname "$mo")")
      install -Dpm0644 "$mo" "$out/share/locale/$locale/LC_MESSAGES/deepin-installer-timezones.mo"
    done
    runHook postInstall
  '';

  meta = {
    description = "Timezone translations used by the GXDE/Deepin daemon";
    homepage = "https://github.com/GXDE-OS/deepin-installer-reborn";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
