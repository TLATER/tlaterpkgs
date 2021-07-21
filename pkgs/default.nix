{ pkgs }:

let
  sources = pkgs.callPackage ../sources.nix { };
  callPackage = pkgs.lib.callPackageWith (pkgs // { inherit sources; });
in {
  eontimer = callPackage ./eontimer.nix { };
  gcs = callPackage ./gcs.nix { };
  pokefinder = callPackage ./pokefinder.nix { };
}
