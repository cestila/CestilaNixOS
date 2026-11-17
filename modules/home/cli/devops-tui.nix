{pkgs, ...}: {
  imports = [
    ./devops-base.nix
  ];

  home.packages = with pkgs; [
    # Herramientas interactivas en terminal (TUI)
    k9s # Panel TUI para visualización y gestión en tiempo real de Kubernetes
    ansible-navigator # TUI oficial para ejecución y depuración de Ansible Playbooks
    lazydocker # Panel TUI para contenedores Docker/Podman
    lazygit # Panel TUI para flujos Git
  ];

  # Aliases útiles para DevOps TUI
  home.shellAliases = {
    k = "kubectl";
    kn = "kubens";
    kc = "kubectx";
    tf = "terraform";
    tg = "terragrunt";
    a = "ansible";
    ap = "ansible-playbook";
    an = "ansible-navigator";
  };
}
