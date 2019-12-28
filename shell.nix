let
  pkgs = (import ./nix/nixpkgs.nix).nixpkgs {};
  easyPureScript = import ./nix/pkgs/easy-purescript.nix { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = [
    easyPureScript.purs
    easyPureScript.spago
    pkgs.nodejs
  ];
}
