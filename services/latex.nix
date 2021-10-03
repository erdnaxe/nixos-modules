{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (texlive.combine {
      inherit (texlive) scheme-medium

      # beamerposter
      beamerposter type1cm tcolorbox environ csquotes biber

      titlepic moderncv fontawesome biblatex multirow arydshln;
    })
  ];
}
