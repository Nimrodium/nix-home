{ config, pkgs, nixgl,zen-browser,dotfiles,... }:

{
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";
  home.stateVersion = "25.05";

  nixGL.packages = nixgl.packages;
  # nixGL.defaultWrapper = "mesa";
  # nixGL.installScripts = [ "mesa" ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  xdg.configFile = {
    # "zed/settings.json".source = "./dotfiles/zed/settings.json";
    # "zed/settings.json".source = "${dotfiles}/zed/settings.json";
  };
  home.sessionVariables = {

    LIBVIRT_DEFAULT_URI = "qemu:///system";
    EDITOR = "micro";
    OLLAMA_MODELS = "/mnt/ssd/ollama-models/";
    OLLAMA_HOST = "0.0.0.0";
    DATA_DIR = "/home/kyle/.open-webui";

  };

  home.packages = [
    pkgs.ytmdesktop
    # pkgs.open-webui
    pkgs.nixgl.nixGLMesa
    pkgs.inconsolata
    pkgs.source-code-pro
    pkgs.krita
    zen-browser.packages.${pkgs.system}.default
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
      package = config.lib.nixGL.wrap pkgs.kitty;
      themeFile = "Tomorrow_Night_Bright";
      font = {
        # name = "inconsolata";
        name = "source code pro";
        size = 11.0;
      };

      settings = {
        shell = "${pkgs.fish}/bin/fish";
        cursor_shape = "block";
        open_url_with = "zen-browser"; # browser
        detect_urls = "yes";
        underline_hyperlinks = "never";
        sync_to_monitor = "never";
        window_padding_width = 5;
        single_window_padding_width = -1;
        tab_bar_edge = "bottom";
        tab_bar_margin_width = 5.0;
        tab_bar_margin_height = 2.0 ;
        tab_bar_style = "powerline";
        tab_bar_align = "left";
        tab_bar_min_tabs = 2;
        tab_switch_strategy  = "previous";
        tab_powerline_style = "slanted";

        active_tab_foreground  = "#000";
        active_tab_background  = "#eee";
        active_tab_font_style  = "bold-italic";
        inactive_tab_foreground= "#444";
        inactive_tab_background= "#999";
        inactive_tab_font_style= "normal";

        background_opacity = 0.3;
        background_blur = 1;
        # font_size =11.0;
      };
    };

    # ytmdestkop.enable = true;
    # hyprls.enable = true;
    # open-webui.enable = true;
    # zoxide.enable = true;
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    fastfetch.enable = true;
    # _2048-in-terminal.enable = true;
    #

    zed-editor = {
      enable = true;
      # extensions = [
      #   # "nix"
      #   # "assembly syntax"
      #   # "github dark default"
      #   # "git firefly"
      #   # "toml"
      #   # "html"
      #   # "xml"
      #   # "activitywatch"
      # ];
      # userSettings = {
      #   theme = "Github Dark Default";
      #   # show_edit_predictions = false;
      #   # agent = {
      #   #   default_profile = "minimal";
      #   #   default_model = {
      #   #     provider = "zed.dev";
      #   #     model = "claude-sonnet-4";
      #   #   };
      #   #   version = "2";
      #   # };
      #   # features = {
      #   #   edit_prediction_provider = "supermaven";
      #   # };
      #   # ui_font_size = 16;
      #   # buffer_font_size = 12.0;
      # };
    };
    git = {
      enable = true;
      userName = "nimrodium";
      userEmail = "nimrodium@protonmail.com";
    };
    fish = {
      enable = true;
      plugins = [];
      interactiveShellInit = ''
        zoxide init --cmd cd fish | source
        fastfetch
      '';
      shellAliases = {

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
}
