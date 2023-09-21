{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  name = "local-bin";

  entries = let
    goLinkStatic = drv: args:
      drv.overrideAttrs ({ ldflags ? [], ... }: {
        CGO_ENABLED = 0;
        ldflags = ldflags ++ [ "-s" "-w" "-extldflags '-static'" ];
      } // args);

    hdf5toolsStatic = pkgsStatic.hdf5.out.overrideAttrs (oa: {
      configureFlags = oa.configureFlags or [] ++ [
        "hdf5_cv_ldouble_to_long_special=no" # disabled except for IBM Power6 Linux
        "hdf5_cv_long_to_ldouble_special=no" # disabled except for IBM Power6 Linux
        "hdf5_cv_ldouble_to_llong_accurate=yes" # enabled except for Mac OS 10.4, SGI IRIX64 6.5 and Powerpc Linux using XL compilers
        "hdf5_cv_llong_to_ldouble_correct=yes" # enabled except Mac OS 10.4 and Powerpc Linux using XL compilers
        "hdf5_cv_disable_some_ldouble_conv=no" # disabled except for IBM ppc64le
      ];
    });

    unisonStatic = stdenvNoCC.mkDerivation (finalAttrs: {
      name = "unison-static";
      version = "2.53.3";
      src = fetchurl {
        url = "https://github.com/bcpierce00/unison/releases/download/v${finalAttrs.version}/unison-${finalAttrs.version}-ubuntu-x86_64-static.tar.gz";
        sha256 = "sha256-y7xsKECpJ9Gl3ZGDfkR8UGi2xiVOWPFnEEEpO5M1u1U=";
      };
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = "install -v -Dt $out/bin unison unison-fsmonitor";
    });

    ncduStatic = stdenvNoCC.mkDerivation (finalAttrs: {
      name = "ncdu-static";
      version = "2.3";
      src = fetchurl {
        url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}-linux-x86_64.tar.gz";
        sha256 = "sha256-nc3Q77Xnfl0r3OF4YVuPl5+RqmY+ggnFq9vgslv2OOg=";
      };
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = "install -v -Dt $out/bin ncdu";
    });

  in [
    { src = "${pkgsStatic.libarchive}/bin/bsdcat"; dst = "bsdcat"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcpio"; dst = "bsdcpio"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdtar"; dst = "bsdtar"; }
    { src = "${pkgsStatic.delta}/bin/delta"; dst = "delta"; }
    { src = "${goLinkStatic pkgs.croc {}}/bin/croc"; dst = "croc"; }
    { src = "${goLinkStatic pkgs.direnv { BASH_PATH = ""; }}/bin/direnv"; dst = "direnv"; }
    { src = "${goLinkStatic pkgs.fq {}}/bin/fq"; dst = "fq"; }
    { src = "${goLinkStatic pkgs.fzf {}}/bin/fzf"; dst = "fzf"; }
    { src = "${hdf5toolsStatic}/bin/h5ls"; dst = "h5ls"; }
    { src = "${ncduStatic}/bin/ncdu"; dst = "ncdu"; }
    { src = "${pkgsStatic.patchelf}/bin/patchelf"; dst = "patchelf"; }
    { src = "${pkgsStatic.progress}/bin/progress"; dst = "progress"; }
    { src = "${pkgsStatic.par2cmdline}/bin/par2"; dst = "par2"; }
    { src = "${pkgsStatic.pv}/bin/pv"; dst = "pv"; }
    #{ src = "${pkgsStatic.ripgrep}/bin/rg"; dst = "rg"; }
    { src = "${pkgsStatic.sqlite}/bin/sqlite3"; dst = "sqlite3"; }
    { src = "${pkgsStatic.tmux}/bin/tmux"; dst = "tmux"; }
    { src = "${pkgsStatic.taskspooler}/bin/.ts-wrapped"; dst = "ts"; }
    { src = "${unisonStatic}/bin/unison"; dst = "unison"; }
    { src = "${unisonStatic}/bin/unison-fsmonitor"; dst = "unison-fsmonitor"; }
    { src = "${goLinkStatic pkgs.wormhole-william {}}/bin/wormhole-william"; dst = "wormhole-william"; }
    { src = "${pkgsStatic.zstd}/bin/zstd"; dst = "zstd"; }
  ];

  copyCommands = map (p: ''
    cp -av ${lib.escapeShellArg "${p.src}"} $out/bin/${p.dst}
    ${pkgs.binutils}/bin/readelf -x .interp $out/bin/${p.dst}
  '') entries;

  gitMinimalStatic = pkgsStatic.gitMinimal.overrideAttrs (oa: {
    doInstallCheck = false;
    # undo patchShebangs and substitutions
    postFixup = oa.postFixup or "" + ''
      find $out -type f -exec grep -Iq . {} \; -print0 |
        xargs -0 -l -t sed -i 's%#!/nix/store/[[:graph:]]*%#!/bin/sh%g; s%/nix/store/[^/]*/bin/\([[:graph:]]*\)%\1%g'
    '';
  });

in
runCommand name {
  preferLocalBuild = true;
  allowSubstitutes = false;
 } ''
  mkdir -p $out/bin $out/libexec
  ${lib.concatStrings copyCommands}
  cp -av ${gitMinimalStatic}/libexec/git-core $out/libexec
''
