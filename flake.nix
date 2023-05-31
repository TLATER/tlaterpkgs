{
  description = "A collection of somewhat specialized nix packages";

  inputs = {
    nixpkgs-maptool.url = "github:rhendric/nixpkgs/rhendric/maptool";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-maptool,
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
        program = "${nixpkgs-maptool.legacyPackages.${system}.maptool}/bin/maptool";
      };

      "servefiles" = {
        type = "app";
        program = "${packages.servefiles}/bin/servefiles";
      };

      "sendurls" = {
        type = "app";
        program = "${packages.servefiles}/bin/sendurls";
      };
    };

    devShells.${system}.default = pkgs.mkShell {buildInputs = with pkgs; [nvfetcher];};
  };
}
