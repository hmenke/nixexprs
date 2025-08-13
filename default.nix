{ pkgs ? import <nixpkgs> {} }:

with pkgs;

lib.recurseIntoAttrs {
  dhcpdoctor = callPackage ./dhcpdoctor {};
  findent-octopus = callPackage ./findent-octopus {};
  klatexformula = libsForQt5.callPackage ./klatexformula {};
  local-bin = import ./local-bin { inherit pkgs; };
  prometheus-slurm-exporter = callPackage ./prometheus-slurm-exporter {};
  rederr = callPackage ./rederr {};
  req2flatpak = callPackage ./req2flatpak {};
  verrou = callPackage ./verrou {};
}
