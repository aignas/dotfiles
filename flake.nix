{
  description = "aignas' dotfiles managed with home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHome = module: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ module ];
      };
    in
    {
      # `home-manager switch --flake .` picks the configuration that is named
      # after the current user, so each machine flavour is keyed by username.
      homeConfigurations = {
        "aignas" = mkHome ./nix/linux.nix;
        "ignas-anikevicius" = mkHome ./nix/ubuntu.nix;
      };

      # The home-manager CLI at the version pinned in flake.lock, so that it
      # can be used before it is installed into the profile:
      #   nix run .#home-manager -- switch --flake .
      packages.${system}.home-manager = home-manager.packages.${system}.default;

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
