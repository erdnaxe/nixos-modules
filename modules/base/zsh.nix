{
  # Oh my Zsh!
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "sudo" "adb" ];
    theme = "agnoster";
  };
}
