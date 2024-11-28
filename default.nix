{ pkgs ? import <nixpkgs> {} }:

with pkgs;

lib.recurseIntoAttrs {
  dhcpdoctor = callPackage ./dhcpdoctor {};
  local-bin = import ./local-bin { inherit pkgs; };
  klatexformula = libsForQt5.callPackage ./klatexformula {};
  prometheus-slurm-exporter = callPackage ./prometheus-slurm-exporter {};
  redu = callPackage ./redu {};
  req2flatpak = callPackage ./req2flatpak {};
  #verrou = callPackage ./verrou {};
}
