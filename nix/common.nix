{ config, lib, pkgs, ... }:

{
  imports = [ ./unfree.nix ];

  manual.html.enable = false;
  manual.manpages.enable = false;
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Keep Nix builds within the memory budget of smaller machines. Building one
  # derivation at a time and only using one core avoids the large RAM spikes
  # caused by several compiler processes running in parallel. bin/renix passes
  # the same limits explicitly and allows overriding them per invocation.
  nix = {
    package = pkgs.nix;
    settings = {
      # The configuration is a flake, see flake.nix at the root of the repo.
      experimental-features = [ "nix-command" "flakes" ];

      max-jobs = 1;
      cores = 1;

      # auto-optimise-store, keep-derivations, substituters and
      # trusted-public-keys are only honoured by the nix daemon for trusted
      # users, and ignored with a warning on every nix call otherwise. Set them
      # in /etc/nix/nix.conf instead, see script/nix-system.conf.
    };
  };

  dotfiles.allowUnfree = [ "claude-code" ];

  home.packages = [
    pkgs.asdf
    pkgs.claude-code
    pkgs.curl
    pkgs.direnv
    pkgs.fd
    pkgs.fzf
    pkgs.ghostscript
    pkgs.github-cli
    pkgs.htop
    pkgs.jq
    pkgs.kind
    pkgs.lf
    pkgs.opentofu
    pkgs.pi-coding-agent
    # A pre-commit replacement, bin/pre-commit forwards to it.
    pkgs.prek
    pkgs.ripgrep
    pkgs.terraform-docs
    pkgs.terragrunt
    pkgs.tig

    # mail
    #pkgs.aerc
    #pkgs.dante
    #upkgs.w3m
    #pkgs.translate-shell

    # nvim dependencies
    pkgs.buf
    pkgs.gopls
    pkgs.lua5_4_compat
    # Python: basedpyright and pyrefly for types, ruff for lint and format.
    pkgs.basedpyright
    pkgs.pyrefly
    pkgs.ruff
    pkgs.rust-analyzer
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.uv
    pkgs.yamlfmt
    pkgs.yamllint

    # bazel and friends
    pkgs.bazelisk

    # blog
    pkgs.zola
  ];

  # gh extensions are discovered in $XDG_DATA_HOME/gh/extensions/<name>/<name>.
  # Only the extension binary is linked instead of adding the package to
  # home.packages, because the package also ships a bin/test, which would
  # shadow the coreutils one on the PATH.
  xdg.dataFile."gh/extensions/gh-stack/gh-stack".source = "${pkgs.gh-stack}/bin/gh-stack";

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
