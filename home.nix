{ config, pkgs,nixgl, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.


  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ytmdesktop
    pkgs.open-webui
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kyle/etc/profile.d/hm-session-vars.sh

  home.sessionVariables = {
    # EDITOR = "emacs";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    EDITOR = "micro";
    OLLAMA_MODELS = "/mnt/ssd/ollama-models/";
    OLLAMA_HOST = "0.0.0.0";
    DATA_DIR = "/home/kyle/.open-webui";
  };

  programs = {
    home-manager.enable = true;

    micro.enable = true;
    helix = {
      enable = true;
      languages = {
        language = [{
          name = "rust";
        }];
      };
      settings = {
        theme = "autumn-night";
      };
    };

    command-not-found.enable = true;
    eza.enable = true;
    btop.enable = true;
    bat.enable = true;
    kitty = {
      enable = true;
      package = config.lib.nixGL.wrappers.mesa pkgs.kitty;
    };

    # ytmdestkop.enable = true;
    # hyprls.enable = true;
    # open-webui.enable = true;
    zoxide.enable = true;
    fastfetch.enable = true;
    # _2048-in-terminal.enable = true;
    fish = {
      enable = true;
      plugins = [];
      interactiveShellInit = ''
        zoxide init --cmd cd fish | source
        fastfetch
      '';
      shellAbbrs = {

        raspi = "ssh -Y kyle@raspi";
        ls = "eza";
        zed = "zeditor";
        hx = "helix";
        edit = "ms-edit";
        showgpu = "lspci -nnk | rg 28:00 -A 5";
        windows = "virsh start win11-gpu-no-spice";
        stopwindows = "virsh shutdown win11-gpu-no-spice";
        soft-reboot = "sudo systemctl soft-reboot";
      };
    };
  };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
}
