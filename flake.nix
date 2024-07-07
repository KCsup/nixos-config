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
    user = "josh";
  
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    specialArgs = { inherit inputs user;};
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
              home-manager.users.${user}.imports = [
                ./modules/home.nix
                ./hosts/laptop/home.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
          }
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
