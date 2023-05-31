{pkgs}: let
  sources = pkgs.callPackage ../sources.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit sources;});
in rec {
  eontimer = callPackage ./eontimer {};
  gcs = callPackage ./gcs.nix {};
  pokefinder = callPackage ./pokefinder.nix {};
  edopro-raw = callPackage ./edopro-raw.nix {};
  edopro = callPackage ./edopro.nix {inherit edopro-raw;};
  servefiles = callPackage ./servefiles.nix {};
}
