#{ lib
#, stdenv
#, buildGoPackage
#, fetchFromGitHub
#}:
with import <nixpkgs> { };

buildGoModule rec {
  pname = "bmpc";
  version = "unstable-2021-12-03";

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "7ba9f2ada796145a01f2af82fcd17d811004e891";
    sha256 = "sha256-s0mxd9pVIprOZYUPak5d1yKFVpYXR0+pnZNcmzawpac=";
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
