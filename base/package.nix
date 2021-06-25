{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  environment.variables = { EDITOR = "vim"; };
}
