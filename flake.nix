{
  description = "Jesse's Nix configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    ags.url = "github:Aylur/ags";
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
  };

  outputs =
    {
      self,
      catppuccin,
      nixpkgs,
      nix-darwin,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./home/desktop/ags {
        inherit inputs;
      };
      # for nixos module home-manager installations
      nixosConfigurations.FW13-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          asztal = self.packages.x86_64-linux.default;
        };
        modules = [
          ./configuration.nix
          ./virtualisation.nix
          ./hardware/FW13-Ryzen7040/hardware-configuration.nix
          catppuccin.nixosModules.catppuccin
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jaid = import ./home/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
      };

      darwinConfigurations."Jesse-MBP" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jaid = import ./home/darwin-home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
        specialArgs = {
          inherit inputs;
          inherit self;
        };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Jesse-MBP".pkgs;
    };
}
