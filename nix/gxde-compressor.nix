{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  gxde-shell-compressor,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-compressor";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-compressor";
    rev = "d8b054f5b047b0a279ee711d1d32c9d96e6de19e";
    hash = "sha256-43JcR0jsVQwuXp5vThzdxOFJ3yTyX6K1pVubxuSRaY4=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dpm0755 src/usr/bin/gxde-compressor $out/bin/gxde-compressor
    patchShebangs $out/bin/gxde-compressor
    wrapProgram $out/bin/gxde-compressor \
      --prefix PATH : ${lib.makeBinPath [ bash gxde-shell-compressor ]}
    runHook postInstall
  '';
  meta = {
    description = "GXDE archive manager";
    homepage = "https://github.com/GXDE-OS/gxde-compressor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gxde-compressor";
  };
})
