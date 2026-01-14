{ pkgs, ... }:

let
  pname = "btdu";
  version = "0.7.2";
  src = fetchTarball "https://github.com/CyberShadow/${pname}/archive/refs/tags/v${version}.tar.gz";
  flake = import "${src}/flake.nix";
  self = null;
  nixpkgs = { legacyPackages = { "${pkgs.stdenv.hostPlatform.system}" = pkgs; }; };
  flake-utils = { lib = { eachDefaultSystem = fn: fn "${pkgs.stdenv.hostPlatform.system}"; }; };
  outputs = flake.outputs { inherit self nixpkgs flake-utils; };
in outputs.packages.btdu-static-x86_64
