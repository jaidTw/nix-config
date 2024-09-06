{
  description = "Jesse's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags";
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    {
      packages.x86_64-linux.default =
        nixpkgs.legacyPackages.x86_64-linux.callPackage ./home/desktop/ags {inherit inputs;};
      # for nixos module home-manager installations
      nixosConfigurations.FW13-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          my-ags = self.packages.x86_64-linux.default;
        };
        modules = [
          ./configuration.nix
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
    };
}
