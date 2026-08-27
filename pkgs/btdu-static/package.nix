{ pkgs, ... }:

let
  pname = "btdu";
  version = "0.7.2";
  src =
    fetchTarball
      #"https://github.com/CyberShadow/btdu/archive/refs/tags/v${version}.tar.gz";
      "https://github.com/hmenke/btdu/archive/8909ef4eca0cbb38bf5956005618309d2931cab6.tar.gz";
  flake = import "${src}/flake.nix";
  self = null;
  nixpkgs = {
    legacyPackages = {
      "${pkgs.stdenv.hostPlatform.system}" = pkgs;
    };
  };
  flake-utils = {
    lib = {
      eachDefaultSystem = fn: fn "${pkgs.stdenv.hostPlatform.system}";
    };
  };
  outputs = flake.outputs { inherit self nixpkgs flake-utils; };
in
outputs.packages.btdu-static-x86_64
