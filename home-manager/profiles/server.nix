{ config, pkgs, lib, ... }: {

  # Install these packages for my user
  home.packages =
    let
      build-system = pkgs.callPackage ../../packages/build-system { };
      drone-gen = pkgs.callPackage ../../packages/drone-gen { };
      gen-module = pkgs.callPackage ../../packages/gen-module { };
      preview-update = pkgs.callPackage ../../packages/preview-update { };
      update-input = pkgs.callPackage ../../packages/update-input { };
      vs-fix = pkgs.callPackage ../../packages/vs-fix { };
    in
    with pkgs; [
      dnsutils
      h
      htop
      iperf3
      nil
      nix-top
      nix-tree
      nixfmt
      nixpkgs-fmt
      unzip

      build-system
      drone-gen
      gen-module
      preview-update
      update-input
      vs-fix

      (pkgs.writeShellScriptBin "ci" ''
        # echo link to woodpecker
        url=$(${pkgs.git}/bin/git config --get remote.origin.url | sed -e 's/\(.*\)git@\(.*\):[0-9\/]*/https:\/\/\2\//g')
        owner=$(echo $url | sed -e 's/.*github.com\/\(.*\)\/.*/\1/g')
        repo=$(echo $url | sed -e 's/.*github.com\/.*\/\(.*\).git/\1/g')
        echo "https://build.lounge.rocks/$owner/$repo"
      ''
      )
    ];

  mayniklas = {
    programs = {
      direnv.enable = true;
      git.enable = true;
      tmux.enable = true;
      vim.enable = true;
      zsh.enable = true;
    };
  };

  # Imports
  imports = [
    ../modules/direnv
    ../modules/git
    ../modules/nvim
    ../modules/tmux
    ../modules/zsh
  ];

  # Include man-pages
  manual.manpages.enable = true;

  programs.command-not-found.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
