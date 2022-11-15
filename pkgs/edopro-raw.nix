{
  sources,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (sources.edopro) pname version src;

  # Disable client updates
  patchPhase = ''
    echo 'noClientUpdates = 1' >> config/system.conf
  '';

  installPhase = ''
    mkdir -p $out/opt/
    cp -r . $out/opt/ProjectIgnis
  '';
}
