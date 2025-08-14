{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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

    extraSpecialArgs = { inherit inputs user;};
  in
  {
    nixosConfigurations = {
      omen = let
        args = {
          isWSL = false;
          hostName = "omen";
        } // extraSpecialArgs;
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = args;
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
              home-manager.extraSpecialArgs = args;
          }
        ];
      };

      framework = let
        args = {
          isWSL = false;
          hostName = "framework";
        } // extraSpecialArgs;
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = args;
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
                ./hosts/framework/home.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = args;
          }
        ];
      };

      wsl = let
        args = {
          isWSL = true;
          hostName = "wsl";
        } // extraSpecialArgs;
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = args;
        system = system;
        modules = [
          ./hosts/wsl/configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
          inputs.home-manager.nixosModules.home-manager
          {
              home-manager.users.${user}.imports = [
                ./modules/home.nix
                ./hosts/wsl/home.nix
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = args;
          }
        ];
      };
    };

    devShells.${system} = {
      java8 = pkgs.mkShell {
        name = "java8";

        buildInputs = [
          pkgs.oraclejdk8
          pkgs.jdt-language-server
          pkgs.gnumake
        ];

        # shellHook = ''
        #   export CLASSPATH="${pkgs.oraclejdk8}/jre/lib/ext/jfxrt.jar:"
        # '';
      };

      java17 = pkgs.mkShell {
        name = "java17";

        buildInputs = with pkgs; [
          jdk17
          jdt-language-server
          kotlin
          # kotlin-language-server
          gradle
        ];
      };

      java21 = pkgs.mkShell {
        name = "java21";

        buildInputs = with pkgs; [
          jdk21
          jdt-language-server
          gradle

          eclipses.eclipse-java
        ];
      };

      python311 = pkgs.mkShell {
        name = "python311";

        buildInputs = with pkgs; [
          python311
          python311Packages.python-lsp-server
          python311Packages.numpy
          python311Packages.pandas
        ];

        shellHook = ''
          export VENV_DIR=".venv"
          if [ ! -d $VENV_DIR ]; then
            python -m venv $VENV_DIR
          fi
          source $VENV_DIR/bin/activate
        '';
      };

      node = pkgs.mkShell {
        name = "node";

        buildInputs = with pkgs; [
          nodejs
          typescript
          nodePackages.typescript-language-server
        ];
      };
      
      deno = pkgs.mkShell {
        name = "deno";

        buildInputs = with pkgs; [
          deno
          typescript
          nodePackages.typescript-language-server
        ];
      };

      rust = pkgs.mkShell {
        name = "rust";

        buildInputs = with pkgs; [
          cargo
          rustc
          bacon
        ];
      };
    };

  };
}
