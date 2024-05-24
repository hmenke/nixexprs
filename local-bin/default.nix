{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  entries = let
    goLinkStatic = drv: args:
      drv.overrideAttrs (oa: {
        CGO_ENABLED = 0;
        ldflags = (oa.ldflags or []) ++ [ "-s" "-w" "-extldflags '-static'" ];
      } // args);

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
    { src = "${goLinkStatic pkgs.age {}}/bin/age"; dst = "age"; }
    { src = "${goLinkStatic pkgs.age {}}/bin/age-keygen"; dst = "age-keygen"; }
    { src = "${pkgsStatic.bat}/bin/.bat-wrapped"; dst = "bat"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcat"; dst = "bsdcat"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcpio"; dst = "bsdcpio"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdtar"; dst = "bsdtar"; }
    { src = "${pkgsStatic.coreutils}/bin/coreutils"; dst = "coreutils"; }
    { src = "${goLinkStatic pkgs.croc {}}/bin/croc"; dst = "croc"; }
    { src = "${pkgsStatic.delta}/bin/delta"; dst = "delta"; }
    { src = "${goLinkStatic pkgs.direnv { BASH_PATH = ""; }}/bin/direnv"; dst = "direnv"; }
    { src = "${pkgsStatic.fd}/bin/fd"; dst = "fd"; }
    { src = "${goLinkStatic pkgs.fq {}}/bin/fq"; dst = "fq"; }
    { src = "${goLinkStatic pkgs.fzf {}}/bin/fzf"; dst = "fzf"; }
    { src = "${goLinkStatic pkgs.gh {}}/bin/gh"; dst = "gh"; }
    { src = "${goLinkStatic pkgs.glab {}}/bin/glab"; dst = "glab"; }
    { src = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/.gocryptfs-wrapped"; dst = "gocryptfs"; }
    { src = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/gocryptfs-xray"; dst = "gocryptfs-xray"; }
    { src = "${goLinkStatic pkgs.gotty {}}/bin/gotty"; dst = "gotty"; }
    { src = "${pkgsStatic.hdf5}/bin/h5ls"; dst = "h5ls"; }
    { src = "${pkgsStatic.hyperfine}/bin/hyperfine"; dst = "hyperfine"; }
    { src = "${goLinkStatic pkgs.lemonade {}}/bin/lemonade"; dst = "lemonade"; }
    { src = "${pkgsStatic.less}/bin/less"; dst = "less"; }
    { src = "${pkgsStatic.lsof}/bin/lsof"; dst = "lsof"; }
    { src = "${pkgsStatic.netcat}/bin/nc"; dst = "nc"; }
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
    { src = "${goLinkStatic sops {}}/bin/sops"; dst = "sops"; }
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
