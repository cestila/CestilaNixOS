{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
