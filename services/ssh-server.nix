{
  # It should NEVER be possible to log in as root via SSH without a key pair.
  # Many bots on Internet constently spams SSH to try to take over.
  # By default NixOS sets `services.openssh.permitRootLogin` to
  # `prohibit-password` except on the installation CD.
  services.openssh.enable = true;

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "185.230.76.0/22"
    ];
  };
}
