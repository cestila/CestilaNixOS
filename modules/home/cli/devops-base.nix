{pkgs, ...}: {
  # Stack base común para DevOps y Administración de Sistemas
  home.packages = with pkgs; [
    # Kubernetes, Helm & Orquestación
    kubectl # CLI oficial de Kubernetes
    kubectx # Cambio rápido de contextos y namespaces de Kubernetes
    kubernetes-helm # Gestor de paquetes Helm
    helmfile # Despliegue declarativo de charts de Helm
    kustomize # Personalización declarativa de YAMLs de Kubernetes
    argocd # CLI de GitOps ArgoCD
    stern # Visualización y seguimiento de logs multi-pod/contenedor

    # Infraestructura como Código (IaC) & Automatización
    terraform # Infraestructura como código de HashiCorp
    terragrunt # Wrapper DRY para Terraform
    tflint # Linter para código Terraform
    trivy # Escáner de seguridad y vulnerabilidades para IaC y contenedores
    ansible # Automatización y gestión de configuración
    ansible-lint # Linter de buenas prácticas para Playbooks
    ansible-builder # Creador de Execution Environments para Ansible

    # Secretos, Cifrado & Vault
    vault # HashiCorp Vault CLI para gestión de secretos
    sops # Cifrado de archivos de configuración y secretos
    age # Herramienta moderna de cifrado simple

    # Clientes Oficiales de Cloud Providers
    google-cloud-sdk # Google Cloud CLI (gcloud, gsutil, bq)
    firebase-tools # Firebase CLI oficial
    awscli2 # Amazon Web Services CLI v2
    azure-cli # Microsoft Azure CLI
    huaweicloud-cli # Huawei Cloud CLI

    # Clientes de Bases de Datos & SQL TUI
    postgresql # Cliente PostgreSQL (psql)
    mariadb.client # Cliente MySQL / MariaDB (mysql)
    usql # Cliente universal para SQL
    pgcli # PostgreSQL CLI enriquecida
    mycli # MySQL CLI enriquecida
    harlequin # Visual SQL IDE en terminal (DuckDB, Postgres, MySQL)

    # Diagnóstico de Red, Seguridad & CI/CD
    nmap # Escaneo de puertos y auditoría de red
    mtr # Traceroute y ping interactivo
    iperf3 # Medición de ancho de banda y rendimiento de red
    httpie # Cliente HTTP moderno e intuitivo
    curlie # La potencia de curl con la sintaxis visual de httpie
    gping # Ping gráfico en tiempo real en terminal
    doggo # Cliente DNS moderno tipo dig
    act # Ejecución de GitHub Actions localmente con contenedores
  ];
}
