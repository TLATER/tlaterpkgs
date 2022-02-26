{ sources, stdenv, autoPatchelfHook, alsa-lib, gccForLibs, libGL, mono, udev
, xorg }:

stdenv.mkDerivation {
  inherit (sources.edopro) pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gccForLibs.lib
    alsa-lib
    libGL
    mono
    udev
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXxf86vm
  ];

  # Disable client updates
  patchPhase = ''
    echo 'noClientUpdates = 1' >> config/system.conf
  '';

  installPhase = ''
    mkdir -p $out/opt/
    cp -r . $out/opt/ProjectIgnis
  '';
}
