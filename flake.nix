{
  description = "Home Manager configuration of kyle";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser.url = "github:conneroisu/zen-browser-flake";
    dotfiles = {
      url = "path:dotfiles";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    { nixpkgs, home-manager, nixgl,zen-browser,dotfiles,... }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };

    in
    {

      homeConfigurations."kyle" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit nixgl; inherit zen-browser; inherit dotfiles; };
      };
    };
}
