{
  sources,
  lib,
  stdenv,
  cmake,
  qt6,
  python3,
}: let
  inherit (qt6) qtbase qttools wrapQtAppsHook;
  inherit (sources) pokefinder;
in
  stdenv.mkDerivation {
    inherit (pokefinder) pname version src;
    buildInputs = [qtbase];
    depsBuildBuild = [cmake qttools];
    nativeBuildInputs = [python3 wrapQtAppsHook];

    patches = [
      ../fix-size_t.patch
    ];

    postPatch = ''
      patchShebangs Source/Core/Resources/embed.py
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp Source/Forms/PokeFinder $out/bin
    '';
  }
