{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

lib.recurseIntoAttrs {
  denet = callPackage ./denet { };
  dhcpdoctor = callPackage ./dhcpdoctor { };
  difftastic = callPackage ./difftastic { };
  findent-octopus = callPackage ./findent-octopus { };
  klatexformula = libsForQt5.callPackage ./klatexformula { };
  local-bin = import ./local-bin { inherit pkgs; };
  mergiraf = callPackage ./mergiraf { };
  pkgcheck = callPackage ./pkgcheck { };
  prometheus-slurm-exporter = callPackage ./prometheus-slurm-exporter { };
  rederr = callPackage ./rederr { };
  req2flatpak = callPackage ./req2flatpak { };
  verrou = callPackage ./verrou { };
  weave = callPackage ./weave { };
}
