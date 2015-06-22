let
  pkgs = import <nixpkgs> { };
  callPackage = pkgs.callPackage;
in {
  voxgen = callPackage ./voxgen { };
}
