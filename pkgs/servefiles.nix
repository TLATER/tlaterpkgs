{
  sources,
  lib,
  stdenv,
  python3,
}:
stdenv.mkDerivation {
  pname = "servefiles";
  inherit (sources.fbi) version src;
  sourceRoot = "source/servefiles";

  propagatedBuildInputs = [python3];

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 servefiles.py $out/bin/servefiles
    install -m 0755 sendurls.py $out/bin/sendurls
  '';

  disallowedReferences =
    lib.optionals (python3.stdenv.hostPlatform != python3.stdenv.buildPlatform)
    [python3.pythonForBuild];
}
