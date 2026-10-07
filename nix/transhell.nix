{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "transhell";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "transhell";
    rev = "12543a71d803da6c45087264ff8dde8ae6e9cefd";
    hash = "sha256-kV4Rzxwjmy5y1vSfugoIKSP3ZlEzMtJs/YqKbpDekz4=";
  };

  nativeBuildInputs = [ bash ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -a src/opt/bashimport $out/opt/
    cp -a src/opt/durapps $out/opt/

    runHook postInstall
  '';

  meta = {
    description = "Shared shell translation library used by GXDE helper scripts";
    homepage = "https://github.com/GXDE-OS/transhell";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
