{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  binaries = let
    goLinkStatic = drv: args:
      drv.overrideAttrs (oa: {
        CGO_ENABLED = 0;
        env = removeAttrs (oa.env or {}) [ "CGO_ENABLED" ];
        ldflags = (oa.ldflags or []) ++ [ "-s" "-w" "-extldflags '-static'" ];
      } // args);

    unisonStatic = (pkgsMusl.unison.override { enableX11 = false; }).overrideAttrs { LDFLAGS = "-static"; };

    ncduStatic = stdenvNoCC.mkDerivation (finalAttrs: {
      name = "ncdu-static";
      version = "2.6";
      src = fetchurl {
        url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-zYU5/f7qGSAXS6QIsb6I5MhXnVRDtxF4+2hBRp+StSc=";
      };
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = "install -v -Dt $out/bin ncdu";
    });

    ripgrepStatic = pkgsStatic.ripgrep.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [ ./0001-Make-jemalloc-optional.patch ];
    });

    ripgrepAllStatic = pkgsStatic.ripgrep-all.overrideAttrs (oa: {
      doCheck = false;
      nativeCheckInputs = null;
      postInstall = null;
    });

    mgStatic = pkgsStatic.mg.overrideAttrs (oa: {
      patches = assert (oa.patches or []) == []; [
        (fetchpatch {
          name = "Add-Ctrl-arrow-Ctrl-PgUp-Dn-to-fundamental-bindings.patch";
          url = "https://github.com/troglobit/mg/commit/4a1ddb3aa158a9e2d8281427972debc6d326a2f8.patch";
          hash = "sha256-TxAO9gJGUoHgnC6IJpkq2Cx5evV3UVgHIsokLwetlg4=";
        })
      ];
      patchFlags = [ "-p2" "-F3" ];
    });

    btopStatic = (pkgsStatic.btop.override { cudaSupport = true; }).overrideAttrs (oa: {
      hardeningDisable = (oa.hardeningDisable or []) ++ [
        "fortify"
      ];
      cmakeFlags = (oa.cmakeFlags or []) ++ [
        "-DBTOP_STATIC:BOOL=ON"
        "-DBTOP_FORTIFY:BOOL=OFF"
      ];
    });

    # https://github.com/NixOS/nixpkgs/pull/350654#issuecomment-2507236711
    ruffStatic = pkgsStatic.ruff.overrideAttrs (_: {
      postInstallCheck = null;
    });

    bfsStatic = pkgsStatic.bfs.overrideAttrs (oa: {
      configurePhase = ''
        runHook preConfigure
        ./configure --prefix=$out --enable-release EXTRA_CFLAGS=-static EXTRA_LDFLAGS=-static
        runHook postConfigure
      '';
    });

    liblinearStatic = pkgsStatic.liblinear.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [ ./0002-liblinear-static.patch ];
      installPhase = ''
        install -Dt $out/lib liblinear.a
        install -D train $bin/bin/liblinear-train
        install -D predict $bin/bin/liblinear-predict
        install -Dm444 -t $dev/include linear.h
      '';
    });

    nmapStatic = pkgsStatic.nmap.override {
      liblinear = liblinearStatic;
      withLua = false;
    };

  in [
    { src = "${goLinkStatic pkgs.age {}}/bin/age"; dst = "age"; }
    { src = "${goLinkStatic pkgs.age {}}/bin/age-keygen"; dst = "age-keygen"; }
    { src = "${pkgsStatic.bat}/bin/.bat-wrapped"; dst = "bat"; }
    { src = "${bfsStatic}/bin/bfs"; dst = "bfs"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcat"; dst = "bsdcat"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdcpio"; dst = "bsdcpio"; }
    { src = "${pkgsStatic.libarchive}/bin/bsdtar"; dst = "bsdtar"; }
    { src = "${btopStatic}/bin/btop"; dst = "btop"; }
    { src = "${pkgsStatic.bubblewrap}/bin/bwrap"; dst = "bwrap"; }
    { src = "${pkgsStatic.coreutils}/bin/coreutils"; dst = "coreutils"; }
    { src = "${goLinkStatic pkgs.croc {}}/bin/croc"; dst = "croc"; }
    { src = "${pkgsStatic.delta}/bin/delta"; dst = "delta"; }
    { src = "${goLinkStatic pkgs.direnv { BASH_PATH = ""; }}/bin/direnv"; dst = "direnv"; }
    { src = "${goLinkStatic pkgs.dive {}}/bin/dive"; dst = "dive"; }
    { src = "${pkgsStatic.fd}/bin/fd"; dst = "fd"; }
    { src = "${goLinkStatic pkgs.fq {}}/bin/fq"; dst = "fq"; }
    { src = "${goLinkStatic pkgs.fzf {}}/bin/fzf"; dst = "fzf"; }
    { src = "${goLinkStatic pkgs.gh {}}/bin/gh"; dst = "gh"; }
    { src = "${goLinkStatic pkgs.glab {}}/bin/glab"; dst = "glab"; }
    { src = "${goLinkStatic pkgs.gobuster {}}/bin/gobuster"; dst = "gobuster"; }
    { src = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/.gocryptfs-wrapped"; dst = "gocryptfs"; }
    { src = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/gocryptfs-xray"; dst = "gocryptfs-xray"; }
    { src = "${goLinkStatic pkgs.gotop {}}/bin/gotop"; dst = "gotop"; }
    { src = "${goLinkStatic pkgs.gotty {}}/bin/gotty"; dst = "gotty"; }
    { src = "${pkgsStatic.hdf5.bin}/bin/h5ls"; dst = "h5ls"; }
    { src = "${pkgsStatic.httm}/bin/httm"; dst = "httm"; }
    { src = "${pkgsStatic.hyperfine}/bin/hyperfine"; dst = "hyperfine"; }
    { src = "${pkgsStatic.jq}/bin/jq"; dst = "jq"; }
    { src = "${goLinkStatic pkgs.lemonade {}}/bin/lemonade"; dst = "lemonade"; }
    { src = "${pkgsStatic.less}/bin/less"; dst = "less"; }
    { src = "${pkgsStatic.lsof}/bin/lsof"; dst = "lsof"; }
    { src = "${mgStatic}/bin/mg"; dst = "mg"; }
    { src = "${pkgsStatic.mtr}/bin/mtr"; dst = "mtr"; }
    { src = "${pkgsStatic.netcat}/bin/nc"; dst = "nc"; }
    { src = "${nmapStatic}/bin/ncat"; dst = "ncat"; }
    { src = "${nmapStatic}/bin/nmap"; dst = "nmap"; }
    { src = "${nmapStatic}/bin/nping"; dst = "nping"; }
    { src = "${ncduStatic}/bin/ncdu"; dst = "ncdu"; }
    { src = "${pkgsStatic.patchelf}/bin/patchelf"; dst = "patchelf"; }
    { src = "${pkgsStatic.par2cmdline}/bin/par2"; dst = "par2"; }
    { src = "${pkgsStatic.progress}/bin/progress"; dst = "progress"; }
    { src = "${pkgsStatic.pv}/bin/pv"; dst = "pv"; }
    { src = "${goLinkStatic pkgs.rclone {}}/bin/.rclone-wrapped"; dst = "rclone"; }
    { src = "${pkgsStatic.reptyr.overrideAttrs (_: { doCheck = false; checkFlags = null; })}/bin/reptyr"; dst = "reptyr"; }
    { src = "${goLinkStatic pkgs.restic {}}/bin/.restic-wrapped"; dst = "restic"; }
    { src = "${ripgrepStatic}/bin/rg"; dst = "rg"; }
    { src = "${ripgrepAllStatic}/bin/rga"; dst = "rga"; }
    { src = "${ripgrepAllStatic}/bin/rga-preproc"; dst = "rga-preproc"; }
    { src = "${ruffStatic}/bin/ruff"; dst = "ruff"; }
    { src = "${pkgsStatic.rustic-rs}/bin/rustic"; dst = "rustic"; }
    { src = "${pkgsStatic.sccache}/bin/sccache"; dst = "sccache"; }
    { src = "${goLinkStatic sops {}}/bin/sops"; dst = "sops"; }
    { src = "${pkgsStatic.sqlite.override { interactive = true; }}/bin/sqlite3"; dst = "sqlite3"; }
    { src = "${goLinkStatic pkgs.subfinder {}}/bin/subfinder"; dst = "subfinder"; }
    { src = "${pkgsStatic.tailspin}/bin/tspin"; dst = "tspin"; }
    { src = "${pkgsStatic.tmux}/bin/tmux"; dst = "tmux"; }
    { src = "${pkgsStatic.taskspooler}/bin/.ts-wrapped"; dst = "ts"; }
    { src = "${pkgsStatic.tree}/bin/tree"; dst = "tree"; }
    { src = "${unisonStatic}/bin/unison"; dst = "unison"; }
    { src = "${unisonStatic}/bin/unison-fsmonitor"; dst = "unison-fsmonitor"; }
    { src = "${goLinkStatic pkgs.upterm {}}/bin/upterm"; dst = "upterm"; }
    { src = "${pkgsStatic.uv}/bin/uv"; dst = "uv"; }
    { src = "${goLinkStatic pkgs.wireproxy {}}/bin/wireproxy"; dst = "wireproxy"; }
    { src = "${goLinkStatic pkgs.wormhole-william {}}/bin/wormhole-william"; dst = "wormhole-william"; }
    { src = "${pkgsStatic.zstd}/bin/zstd"; dst = "zstd"; }
  ];

  scripts = let
    lesspipe' = stdenv.mkDerivation {
      name = lesspipe.name;
      src = lesspipe.src;
      meta = lesspipe.meta;
      nativeBuildInputs = [ perl ];
      configureFlags = [ "--prefix=/" ];
      configurePlatforms = [ ];
      dontBuild = true;
      installFlags = [ "DESTDIR=$(out)" ];
      dontPatchShebangs = true;
    };
  in [
    { src = "${lesspipe'}/bin/lesspipe.sh"; dst = "lesspipe.sh"; }
  ];

  copyBinaries = map (p: ''
    2>&1 ${pkgs.binutils}/bin/readelf -x .interp ${lib.escapeShellArg "${p.src}"} |
      tee /dev/stderr | grep -qF "Warning: Section '.interp' was not dumped because it does not exist"
    ln -sv ${lib.escapeShellArg "${p.src}"} $out/bin/${p.dst}
  '') binaries;

  copyScripts = map (p: ''
    grep -F '/nix/store' "${p.src}" && exit 1
    ln -sv ${lib.escapeShellArg "${p.src}"} $out/bin/${p.dst}
  '') scripts;

  gitMinimalStatic = pkgsStatic.gitMinimal.overrideAttrs (oa: {
    doInstallCheck = false;
    # force detection of curl
    configureFlags = oa.configureFlags or [] ++ [
      "ac_cv_lib_curl_curl_global_init=yes"
    ];
    # undo patchShebangs and substitutions
    postFixup = oa.postFixup or "" + ''
      find $out -type f -exec grep -Iq . {} \; -print0 |
        xargs -0 -l -t sed -i 's%#!/nix/store/[[:graph:]]*%#!/bin/sh%g; s%/nix/store/[^/]*/bin/\([[:graph:]]*\)%\1%g'
    '';
    # libidn2 also defines `error'
    LDFLAGS = (oa.LDFLAGS or "") + " -z muldefs";
  });

in
pkgs.stdenvNoCC.mkDerivation {
  name = "local-bin";
  phases = [ "installPhase" "fixupPhase" ];
  dontPatchShebangs = true;
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    ${lib.concatStrings copyBinaries}
    ${lib.concatStrings copyScripts}
    ln -s ${gitMinimalStatic}/libexec/git-core $out/libexec/git-core
  '';
}
