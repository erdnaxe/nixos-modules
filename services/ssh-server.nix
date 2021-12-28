{
  # It should NEVER be possible to log in as root via SSH without a key pair.
  # Many bots on Internet constently spams SSH to try to take over.
  # By default NixOS sets `services.openssh.permitRootLogin` to
  # `prohibit-password` except on the installation CD.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
