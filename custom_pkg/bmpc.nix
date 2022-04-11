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
    rev = "ff30d45bd5bc2b35cc307c1bbe9f7e976a92c7cc";
    sha256 = "sha256-FiLKDb/Oel7U3h7TbMte4HjmKiArfT6qAw0CArT+fwU=";
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
