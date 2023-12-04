{ pkgs ? import <nixpkgs> {} }:

with pkgs;

lib.recurseIntoAttrs {
  dhcpdoctor = callPackage ./dhcpdoctor {};
  local-bin = import ./local-bin { inherit pkgs; };
  klatexformula = libsForQt5.callPackage ./klatexformula {};
  prometheus-slurm-exporter = callPackage ./prometheus-slurm-exporter {};
}
