{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:
let
  pythonEnv = python3.withPackages (ps: [ ps.chardet ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zipu";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "zipu";
    rev = "14cba98c2b19642f12d14711192e40ddde930ef7";
    hash = "sha256-MrboU7KP6vx7RltxM/n1HDo6M44tUFtqZCxWGDiOXno=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 src/usr/bin/zipu $out/bin/zipu
    patchShebangs $out/bin/zipu
    wrapProgram $out/bin/zipu --prefix PATH : ${pythonEnv}/bin

    runHook postInstall
  '';

  meta = {
    description = "Unicode-aware ZIP extraction utility used by GXDE Shell Compressor";
    homepage = "https://github.com/GXDE-OS/zipu";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "zipu";
  };
})
