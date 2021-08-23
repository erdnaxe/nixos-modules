#{ lib
#, stdenv
#, buildGoPackage
#, fetchFromGitHub
#}:
with import <nixpkgs> {};

buildGoModule rec {
  pname = "bmpc";
  version = "unstable-2021-07-04";

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "eb997d5dae1c8e498217aa460971526e60f59560";
    sha256 = "1ligiy0ldmj3zhcl3gpjm4s6qjxh8bga89h8fiy14pr3xz6xdf44";
  };

  vendorSha256 = "0gzd6kckjm83n1qxmz60zv22hdgk6bb6zqqwb7a5gkzazjipqhkp";

  meta = with lib; {
    description = " Minimalist MPD client in browser";
    homepage = "https://github.com/erdnaxe/bmpc";
    license = licenses.mit;
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
