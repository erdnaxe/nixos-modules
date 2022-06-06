with import <nixpkgs> { };

buildGoModule rec {
  pname = "bmpc";
  version = "unstable-2021-12-03";

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "128b6a082b64ca6d56cbe4ecde88d5bbce5205a5";
    hash = "sha256-xMWYYIcBddIcmSPMjeoC4S0FJ4tkoNE3yoGYFEtCi1o=";
  };

  vendorSha256 = "sha256-cRv++pKboUblZlWrIMOtb8OZFRfrrBqRyPqDa89/REA=";

  meta = with lib; {
    description = " Minimalist MPD client in browser";
    homepage = "https://github.com/erdnaxe/bmpc";
    license = licenses.mit;
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
