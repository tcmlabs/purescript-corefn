let
  rev = "19.09";
  src = builtins.fetchTarball {
    sha256 = "0mhqhq21y5vrr1f30qd2bvydv4bbbslvyzclhw0kdxmkgg3z4c92";
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  };
in {
  inherit rev src;
  nixpkgs = import src;
}
