{profile, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      fastfetch
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
    '';
    shellAliases = {
      fr = "nh os switch --hostname ${profile}";
      fu = "nh os switch --hostname ${profile} --update";
      cnu = "cnixcli update";
      zu = "echo \"[DEPRECATED] 'zu' is deprecated; using 'cnu'\" >&2 && cnixcli update";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      ".." = "cd ..";
    };
  };
}
