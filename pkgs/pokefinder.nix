{ sources, lib, stdenv, cmake, libsForQt5 }:

let
  inherit (libsForQt5.qt5) qtbase qttools wrapQtAppsHook;
  inherit (sources) pokefinder;

in stdenv.mkDerivation {
  inherit (pokefinder) pname version src;
  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake qttools wrapQtAppsHook ];

  # Fix a bug in the codebase
  patchPhase = ''
    substituteInPlace Source/Core/Util/EncounterSlot.cpp --replace size_t std::size_t
    substituteInPlace Source/Core/Util/IVChecker.cpp --replace size_t std::size_t
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp Source/Forms/PokeFinder $out/bin
  '';
}
