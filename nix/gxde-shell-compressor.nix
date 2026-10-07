{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  zipu,
  garma,
  p7zip,
  gnutar,
  bzip2,
  xz,
  pigz,
  zenity,
  util-linux,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-shell-compressor";
  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-shell-compressor";
    rev = "453a12c945e72bfbfe82912956bbc6c3d511fc5c";
    hash = "sha256-NhpWX67AWvQJ4s2bZYjmcMSNx/8jTK4n06uBVOyalz4=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dpm0755 src/usr/bin/gxde-shell-compressor $out/bin/gxde-shell-compressor
    patchShebangs $out/bin/gxde-shell-compressor
    wrapProgram $out/bin/gxde-shell-compressor \
      --prefix PATH : ${lib.makeBinPath [ bash zipu garma p7zip gnutar bzip2 xz pigz zenity util-linux ]}
    runHook postInstall
  '';
  meta = {
    description = "GXDE shell compressor integration";
    homepage = "https://github.com/GXDE-OS/gxde-shell-compressor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gxde-shell-compressor";
  };
})
