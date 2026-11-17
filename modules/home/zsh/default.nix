{
  profile,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./zshrc-personal.nix
  ];

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "regexp" "root" "line"];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    oh-my-zsh = {
      enable = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    initContent = ''
      bindkey "\eh" backward-word
      bindkey "\ej" down-line-or-history
      bindkey "\ek" up-line-or-history
      bindkey "\el" forward-word
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
      if [ -f $HOME/.zshrc.local ]; then
        source $HOME/.zshrc.local
      fi
    '';

    shellAliases = {
      # DevOps & Containers
      docker = "podman";
      d = "podman";
      pc = "podman-compose";
      k = "kubectl";

      # Git
      g = "git";
      gp = "git push";
      gl = "git pull";
      gst = "git status";

      # System & Utilities
      zj = "zellij";
      nix-fmt-all = "nix fmt ./";
      c = "clear";
      fr = "nh os switch --hostname ${profile}";
      fu = "nh os switch --hostname ${profile} --update";
      cnu = "cnixcli update";
      zu = "echo \"[DEPRECATED] 'zu' is deprecated; using 'cnu'\" >&2 && cnixcli update";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      man = "batman";
    };
  };
}
