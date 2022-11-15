{pkgs}: let
  sources = pkgs.callPackage ../sources.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit sources;});
in rec {
  dicelib = callPackage ./dicelib.nix {};
  eontimer = callPackage ./eontimer.nix {};
  gcs = callPackage ./gcs.nix {};
  pokefinder = callPackage ./pokefinder.nix {};
  edopro-raw = callPackage ./edopro-raw.nix {};
  edopro = callPackage ./edopro.nix {inherit edopro-raw;};
  maptool = callPackage ./maptool.nix {inherit dicelib;};
}
