{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-sound-theme";
  version = "25.0u1";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-sound-theme";
    rev = "557be949e770d1077818b07716c9708325949f6e";
    hash = "sha256-hw4rQ9JP3dn5tIgBtlYa/Z9OFgOJBQE+8Uv/rmgtCls=";
  };

  dontConfigure = true;
  dontBuild = true;

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = {
    description = "GXDE sound theme";
    homepage = "https://github.com/GXDE-OS/gxde-sound-theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
