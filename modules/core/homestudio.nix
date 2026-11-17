{username, ...}: {
  # Optimizaciones del Kernel y Sistema para Producción de Audio / Home Studio
  boot.kernel.sysctl = {
    # Reduce uso de swap para evitar cortes (xruns) en grabaciones
    "vm.swappiness" = 10;
  };

  # Prioridades y límites de tiempo real (Realtime / Low Latency) para el grupo de audio
  security = {
    rtkit.enable = true;
    pam.loginLimits = [
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-19";
      }
    ];
  };

  # Aceleración gráfica por hardware para plugins e interfaces de Windows (Vulkan, OpenGL, Direct3D 32/64 bits)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Asegurar que el usuario pertenezca al grupo audio
  users.users.${username}.extraGroups = ["audio"];
}
