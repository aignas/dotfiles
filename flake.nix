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
        modules = [ module ./nix/internal.nix ];
      };
    in
    {
      # `home-manager switch --flake .` picks the configuration that is named
      # after the current user, so each machine flavour is keyed by username.
      homeConfigurations = {
        "aignas" = mkHome ./nix/linux.nix;
        "ignas-anikevicius" = mkHome ./nix/ubuntu.nix;
      };

      packages.${system} = {
        # Single command bootstrap of a new machine:
        #   nix run github:aignas/dotfiles
        # Clones the repo, links it to ~/.dotfiles and hands over to
        # script/bootstrap from the clone, which applies the configuration.
        default = pkgs.writeShellApplication {
          name = "dotfiles-bootstrap";
          runtimeInputs = [ pkgs.git ];
          text = builtins.readFile ./script/nix-bootstrap.sh;
        };

        # The home-manager CLI at the version pinned in flake.lock, so that it
        # can be used before it is installed into the profile:
        #   nix run .#home-manager -- switch --flake .
        home-manager = home-manager.packages.${system}.default;
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/dotfiles-bootstrap";
        meta.description = "Clone the dotfiles and apply them to this machine";
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
