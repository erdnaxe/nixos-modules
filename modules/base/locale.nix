# We keep the default english locale, but we change timezone and keymap
{
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";
  services.xserver.layout = "fr";

  # Approximative geographic location
  # This is useful for redshift
  location.latitude = 48.85;
  location.longitude = 2.35;
}
