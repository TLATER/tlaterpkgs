{
  description = "A collection of somewhat specialized nix packages";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
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

        devShell = pkgs.mkShell { buildInputs = with pkgs; [ nvfetcher ]; };
      });
}
