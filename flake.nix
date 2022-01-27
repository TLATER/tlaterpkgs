{
  description = "A collection of somewhat specialized nix packages";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nvfetcher = {
      url =
        "github:berberman/nvfetcher?rev=ba3366421ff66a06f4176780dff5e8373512bfba";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nvfetcher }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages = import ./pkgs { inherit pkgs; };
        apps = let packages = self.packages.${system};
        in {
          "EonTimer" = {
            type = "app";
            program = "${packages.eontimer}/bin/EonTimer";
          };

          "PokeFinder" = {
            type = "app";
            program = "${packages.pokefinder}/bin/PokeFinder";
          };

          "gcs" = {
            type = "app";
            program = "${packages.gcs}/bin/gcs";
          };
        };
      });
}
