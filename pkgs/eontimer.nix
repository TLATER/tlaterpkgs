{ sources, lib, stdenv, python3Packages, cmake, libsForQt5, sfml }:

let
  inherit (libsForQt5) qtbase qtsvg qttools wrapQtAppsHook;
  inherit (sources) eontimer qtsass;
  inherit (python3Packages) buildPythonPackage libsass pyqt5;
  qtsass-pkg = buildPythonPackage {
    inherit (qtsass) pname version src;
    propagatedBuildInputs = [ libsass pyqt5 ];
  };

in stdenv.mkDerivation {
  inherit (eontimer) pname version src;
  buildInputs = [ qtbase sfml qtsass-pkg ];
  nativeBuildInputs = [ cmake qtsvg qttools wrapQtAppsHook ];

  preBuild = ''
    python3 -m qtsass -o ../resources/styles ../resources/styles
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp EonTimer $out/bin
  '';
}
