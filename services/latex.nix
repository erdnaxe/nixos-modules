{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [
      (texlive.combine {
        inherit (texlive)
          scheme-medium

          # beamerposter
          beamerposter type1cm tcolorbox environ csquotes biber

          animate zref media9 ocgx2
          titlepic moderncv fontawesome fontawesome5 biblatex multirow arydshln

          pgfplots wrapfig;
      })
    ];
}
