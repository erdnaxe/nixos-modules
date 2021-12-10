#{ lib
#, stdenv
#, buildGoPackage
#, fetchFromGitHub
#}:
with import <nixpkgs> {};

buildGoModule rec {
  pname = "bmpc";
  version = "unstable-2021-12-03";

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "647cfd17fc37789c179358291f291a45a02df40c";
    sha256 = "12i26qkpf908mszvpn1wcsbnfjfw75gaghqqf3z7fgvpdnam57da";
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
