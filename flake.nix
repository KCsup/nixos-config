{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    user = "josh";
  
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    specialArgs = { inherit inputs user;};
  in
  {
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs user;

          isWSL = false;
        };
        modules = [
          ./hosts/omen/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
              home-manager.users.${user}.imports = [
                ./modules/home.nix
                ./hosts/omen/home.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };

      framework = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs user;

          isWSL = false;
        };
	      modules = [
          ./hosts/framework/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          # inputs.nixos-hardware.nixosModules.common-cpu-amd
          # inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
          # inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          {
              home-manager.users.${user}.imports = [
                ./modules/home.nix
                # ./hosts/framework/home.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs user;

          isWSL = true;
        };
        system = system;
        modules = [
          ./hosts/wsl/configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
          inputs.home-manager.nixosModules.home-manager
          {
              home-manager.users.${user}.imports = [
                ./modules/home.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };

  };
}
