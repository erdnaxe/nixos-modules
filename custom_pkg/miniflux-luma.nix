with import <nixpkgs> {};

buildGoModule rec {
  pname = "miniflux-luma";
  version = "unstable-2022-05-29";

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = pname;
    rev = "e6d3bac72bcd071a555abc1d446a9ea5b5d9b84c";
    sha256 = "sha256-YzvUQFgNa4MJOWWuf0Bgz8G/QIHt0pC92dpKATvKZAc=";
  };

  vendorSha256 = "sha256-d1Smkb6azTaF5DG/oHkagPgwPassOcKlGU5CPq/Zm+s=";

  meta = with lib; {
    description = "Atom feed exporter for Miniflux starred items";
    homepage = "https://github.com/erdnaxe/miniflux-luma";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
