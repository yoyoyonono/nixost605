{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-flatpak, ... }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
            ./configuration.nix
            inputs.home-manager.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
    };
}
