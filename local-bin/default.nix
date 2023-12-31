{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  entries = let
    goLinkStatic = drv: args:
      drv.overrideAttrs (oa: {
        CGO_ENABLED = 0;
        ldflags = (oa.ldflags or []) ++ [ "-s" "-w" "-extldflags '-static'" ];
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

    unisonStatic = (pkgsMusl.unison.override { enableX11 = false; }).overrideAttrs { LDFLAGS = "-static"; };

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

    ripgrepStatic = pkgsStatic.ripgrep.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [ ./0001-Make-jemalloc-optional.patch ];
    });

  in [
    { src = "${pkgsStatic.bat}/bin/.bat-wrapped"; dst = "bat"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcat"; dst = "bsdcat"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcpio"; dst = "bsdcpio"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdtar"; dst = "bsdtar"; }
    { src = "${pkgsStatic.coreutils}/bin/coreutils"; dst = "coreutils"; }
    { src = "${goLinkStatic pkgs.croc {}}/bin/croc"; dst = "croc"; }
    { src = "${pkgsStatic.delta}/bin/delta"; dst = "delta"; }
    { src = "${goLinkStatic pkgs.direnv { BASH_PATH = ""; }}/bin/direnv"; dst = "direnv"; }
    { src = "${pkgsStatic.fd}/bin/fd"; dst = "fd"; }
    { src = "${pkgsStatic.file}/bin/file"; dst = "file"; }
    { src = "${goLinkStatic pkgs.fq {}}/bin/fq"; dst = "fq"; }
    { src = "${goLinkStatic pkgs.fzf {}}/bin/fzf"; dst = "fzf"; }
    { src = "${goLinkStatic pkgs.gh {}}/bin/gh"; dst = "gh"; }
    { src = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/.gocryptfs-wrapped"; dst = "gocryptfs"; }
    { src = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/gocryptfs-xray"; dst = "gocryptfs-xray"; }
    { src = "${goLinkStatic pkgs.gotty {}}/bin/gotty"; dst = "gotty"; }
    { src = "${hdf5toolsStatic}/bin/h5ls"; dst = "h5ls"; }
    { src = "${goLinkStatic pkgs.lemonade {}}/bin/lemonade"; dst = "lemonade"; }
    { src = "${pkgsStatic.less}/bin/less"; dst = "less"; }
    { src = "${pkgsStatic.lsof}/bin/lsof"; dst = "lsof"; }
    { src = "${ncduStatic}/bin/ncdu"; dst = "ncdu"; }
    { src = "${pkgsStatic.patchelf}/bin/patchelf"; dst = "patchelf"; }
    { src = "${pkgsStatic.par2cmdline}/bin/par2"; dst = "par2"; }
    { src = "${pkgsStatic.progress}/bin/progress"; dst = "progress"; }
    { src = "${pkgsStatic.pv}/bin/pv"; dst = "pv"; }
    { src = "${goLinkStatic pkgs.rclone {}}/bin/.rclone-wrapped"; dst = "rclone"; }
    { src = "${pkgsStatic.reptyr.overrideAttrs (_: { doCheck = false; checkFlags = null; })}/bin/reptyr"; dst = "reptyr"; }
    { src = "${goLinkStatic pkgs.restic {}}/bin/.restic-wrapped"; dst = "restic"; }
    { src = "${ripgrepStatic}/bin/rg"; dst = "rg"; }
    { src = "${pkgsStatic.ruff}/bin/ruff"; dst = "ruff"; }
    { src = "${pkgsStatic.sqlite}/bin/sqlite3"; dst = "sqlite3"; }
    { src = "${pkgsStatic.tailspin}/bin/tspin"; dst = "tspin"; }
    { src = "${pkgsStatic.tmux}/bin/tmux"; dst = "tmux"; }
    { src = "${pkgsStatic.taskspooler}/bin/.ts-wrapped"; dst = "ts"; }
    { src = "${pkgsStatic.tree}/bin/tree"; dst = "tree"; }
    { src = "${unisonStatic}/bin/unison"; dst = "unison"; }
    { src = "${unisonStatic}/bin/unison-fsmonitor"; dst = "unison-fsmonitor"; }
    { src = "${goLinkStatic pkgs.upterm {}}/bin/upterm"; dst = "upterm"; }
    { src = "${goLinkStatic pkgs.wormhole-william {}}/bin/wormhole-william"; dst = "wormhole-william"; }
    { src = "${pkgsStatic.zstd}/bin/zstd"; dst = "zstd"; }
  ];

  copyCommands = map (p: ''
    ${pkgs.binutils}/bin/readelf -x .interp ${lib.escapeShellArg "${p.src}"}
    ln -sv ${lib.escapeShellArg "${p.src}"} $out/bin/${p.dst}
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
pkgs.stdenvNoCC.mkDerivation {
  name = "local-bin";
  phases = [ "installPhase" "fixupPhase" ];
  dontPatchShebangs = true;
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    ${lib.concatStrings copyCommands}
    ln -s ${gitMinimalStatic}/libexec/git-core $out/libexec/git-core
  '';
}
