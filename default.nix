{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

lib.recurseIntoAttrs ({
  local-bin = import ./local-bin { inherit pkgs; };
} // lib.filesystem.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./pkgs;
})
