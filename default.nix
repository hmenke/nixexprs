{ pkgs ? import <nixpkgs> {} }:

pkgs.lib.recurseIntoAttrs {
  local-bin = import ./local-bin.nix { inherit pkgs; };
}
