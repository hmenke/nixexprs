{ pkgs ? import <nixpkgs> {} }:

with pkgs;

lib.recurseIntoAttrs {
  local-bin = import ./local-bin { inherit pkgs; };
  klatexformula = libsForQt5.callPackage ./klatexformula {};
  prometheus-slurm-exporter = callPackage ./prometheus-slurm-exporter {};
}
