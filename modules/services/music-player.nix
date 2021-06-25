{
  home-manager.users.erdnaxe = {
    # Music player deamon on 127.0.0.1:6600
    services.mpd = {
      enable = true;
      musicDirectory = "/home/erdnaxe/Music";
      extraConfig = ''
        audio_output {
            type "pulse"
            name "PulseAudio"
        }
        audio_output {
            type "httpd"
            name "HTTP Stream"
            encoder "opus"
            port "8000"
        }
      '';
    };
  };
}
