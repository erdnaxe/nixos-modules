{
  # Oh my Zsh!
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "adb" ];
    theme = "agnoster";
  };
}
