{pkgs, ...}: {
  home.packages = with pkgs; [zsh];

  home.file."./.zshrc-personal".text = ''

    # This file allows you to define your own aliases, functions, etc
    # below are just some examples of what you can use this file for

      #!/usr/bin/env zsh
      # Set defaults
      #

      #alias c="clear"
      PATH=$HOME/.local/bin:$PATH


  '';
}
