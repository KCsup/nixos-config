{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
          # {
          #     home-manager.users.josh = import ./home.nix;
          #     home-manager.useGlobalPkgs = true;
          #     home-manager.useUserPackages = true;
          #     home-manager.extraSpecialArgs = { inherit inputs; };
          # }
        ];
      };

    # packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (system:
    #   let
    #     pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    #   in
    #   {
    #     slippi = pkgs.callPackage ./applications/slippi { };
    #   }
    # );
  };
}
