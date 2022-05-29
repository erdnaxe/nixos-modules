with import <nixpkgs> {};

buildGoModule rec {
  pname = "miniflux-luma";
  version = "unstable-2022-05-29";

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = pname;
    rev = "d0e5c0c54767503468a300654a540edfe47678fc";
    sha256 = "sha256-6Hv+q8r4P1iALSUKh0YE3pAwk+HJVXc3Vk997Bvd69g=";
  };

  vendorSha256 = "sha256-d1Smkb6azTaF5DG/oHkagPgwPassOcKlGU5CPq/Zm+s=";

  meta = with lib; {
    description = "Atom feed exporter for Miniflux starred items";
    homepage = "https://github.com/erdnaxe/miniflux-luma";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
