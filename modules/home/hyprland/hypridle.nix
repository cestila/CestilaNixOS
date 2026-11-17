{...}: {
  services = {
    hypridle = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({action = \"on\"})'";
          ignore_dbus_inhibit = false;
        };
        listener = [
          # Inactividad general: bloquear sesión a los 5 minutos (300s)
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          # Inactividad general: apagar pantalla (DPMS off) a los 5.5 minutos (330s)
          # Ahorra energía del monitor/panel sin suspender el equipo ni congelar servicios de fondo.
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({action = \"off\"})'";
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({action = \"on\"})'";
          }
        ];
      };
    };
  };
}
