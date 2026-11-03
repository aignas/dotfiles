{ config, lib, pkgs, ... }:

let
  # Track the upstream `stable` branch of the pi coding agent, which is not
  # installed through the pinned nixpkgs channel.
  piSrc = builtins.fetchGit {
    url = "https://github.com/earendil-works/pi";
    ref = "stable";
    # Avoid the "could not update mtime" warning from Nix's packed-refs cache
    # when refreshing a branch reference.
    shallow = true;
  };
  pi = pkgs.callPackage (piSrc + "/nix/package.nix") { source = piSrc; };

  # opencode 2.2.5 in the current nixpkgs has a stale fixed-output hash and
  # fails to build. Pin the nixpkgs revision that still packaged 2.2.1. Its
  # output is available from cache.nixos.org, so this does not build opencode
  # locally.
  opencodeNixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/3e662c7cafceb2a65f612e1da9dd39f82eb39ad0.tar.gz";
  };
  opencode = (import opencodeNixpkgs {
    system = builtins.currentSystem;
    config = { };
    overlays = [ ];
  }).opencode;

  # Pi installs declared npm and git packages on first launch. Keep the
  # declarations here so a fresh machine gets them without manual `pi install`
  # commands.
  piPackages = [
    "npm:@narumitw/pi-caffeinate"
    "https://github.com/elidickinson/pi-claude-bridge"
  ];
in
{
  manual.html.enable = false;
  manual.manpages.enable = false;
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Use the pinned opencode 2.2.1 package from above everywhere `pkgs.opencode`
  # is referenced (linux.nix and ubuntu.nix).
  nixpkgs.overlays = [
    (_final: _prev: {
      opencode = opencode;
    })
  ];

  # Keep Nix builds within the memory budget of smaller machines. Building one
  # derivation at a time and only using one core avoids the large RAM spikes
  # caused by several compiler processes running in parallel. bin/renix passes
  # the same limits explicitly and allows overriding them per invocation.
  nix = {
    package = pkgs.nix;
    settings = {
      max-jobs = 1;
      cores = 1;

      # Deduplicate identical files in the store and do not keep build inputs
      # around after the packages have been built.
      auto-optimise-store = true;
      keep-derivations = false;

      # Prefer binaries from the caches so that fewer derivations have to be
      # built locally in the first place.
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  home.packages = [
    pkgs.asdf
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
    pi
    pkgs.pre-commit
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
    pkgs.pyright
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

  home.sessionVariables = {
  };

  # Pi keeps its settings in a writable file and rewrites it while running, so
  # it cannot be a read-only Home Manager symlink. Merge the package
  # declarations into it during activation instead. Pi installs missing npm and
  # git packages on the next launch.
  home.activation.piPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.pi/agent/settings.json"

    if [ ! -e "$settings" ]; then
      mkdir -p "$(dirname "$settings")"
      printf '{}\n' > "$settings"
    fi

    if ${pkgs.jq}/bin/jq empty "$settings" >/dev/null 2>&1; then
      tmp="$(mktemp "$settings.XXXXXX")"
      if ${pkgs.jq}/bin/jq \
        --argjson packages '${builtins.toJSON piPackages}' \
        '.packages = (((if (.packages | type) == "array" then .packages else [] end) + $packages) | unique)' \
        "$settings" > "$tmp"; then
        mv "$tmp" "$settings"
      else
        rm -f "$tmp"
        echo "warning: could not update $settings; Pi packages were not updated" >&2
      fi
    else
      echo "warning: $settings is not valid JSON; Pi packages were not updated" >&2
    fi
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
