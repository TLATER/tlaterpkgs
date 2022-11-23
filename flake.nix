{
  description = "A collection of somewhat specialized nix packages";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = import ./pkgs {inherit pkgs;};

    apps.${system} = let
      packages = self.packages.${system};
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

      "EDOPro" = {
        type = "app";
        program = "${packages.edopro}/bin/edopro";
      };

      "maptool" = {
        type = "app";
        program = "${packages.maptool}/bin/MapTool";
      };
    };

    devShells.${system}.default = pkgs.mkShell {buildInputs = with pkgs; [nvfetcher];};
  };
}
