{
  lib,
  stdenv,
  fetchFromGitHub,
  gxde-api,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gxde-wallpapers";
  version = "1.7.49";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "gxde-wallpapers";
    rev = "3169951085192c93bee6234d693f581dc947f06b";
    hash = "sha256-B3tSbSZTbYu4Xpzu7pAxrzNOaku2qAcTb1Xzdyx7n4E=";
  };

  nativeBuildInputs = [ gxde-api ];

  dontConfigure = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/usr/lib/deepin-api/image-blur' '${gxde-api}/lib/deepin-api/image-blur'
  '';

  buildPhase = ''
    runHook preBuild
    make prepare
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wallpapers $out/var/cache
    cp -a deepin deepin-community deepin-solidwallpapers $out/share/wallpapers/
    cp -a image-blur $out/var/cache/

    runHook postInstall
  '';

  meta = {
    description = "GXDE wallpapers";
    homepage = "https://github.com/GXDE-OS/gxde-wallpapers";
    license = with lib.licenses; [ cc-by-30 cc-by-40 gpl3Plus ];
    platforms = lib.platforms.linux;
  };
})
