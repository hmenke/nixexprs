{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  binaries = let
    goLinkStatic = drv: args:
      drv.overrideAttrs (oa: {
        env.CGO_ENABLED = 0;
        ldflags = (oa.ldflags or []) ++ [ "-s" "-w" "-extldflags '-static'" ];
      } // args);

    unisonStatic = (pkgsMusl.unison.override { enableX11 = false; }).overrideAttrs { LDFLAGS = "-static"; };

    ncduStatic = stdenvNoCC.mkDerivation (finalAttrs: {
      name = "ncdu-static";
      version = "2.8.1";
      src = fetchurl {
        url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-1yrKsLuZIEu3p6635DgcY6om2isq0LxySRhpaJfcUyg=";
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

    nmapStatic = (pkgsStatic.nmap.override {
      liblinear = liblinearStatic;
      withLua = false;
    }).overrideAttrs (oa: {
      configureFlags = (oa.configureFlags or []) ++ [
        "--without-libnl"
      ];
    });

    # HACK: work around https://github.com/NixOS/nixpkgs/issues/177129
    # Though this is an issue between Clang and GCC,
    # so it may not get fixed anytime soon...
    empty-libgcc_eh = stdenv.mkDerivation {
      pname = "empty-libgcc_eh";
      version = "0";
      dontUnpack = true;
      installPhase = ''
        mkdir -p "$out"/lib
        "${binutils}"/bin/ar r "$out"/lib/libgcc_eh.a
      '';
    };

    bzip3Static = pkgsStatic.bzip3.overrideAttrs (oa: {
      buildInputs = (oa.buildInputs or []) ++ [ empty-libgcc_eh ];
    });

    ugrepStatic = pkgsStatic.ugrep.override {
      bzip3 = bzip3Static;
    };

    findent-octopus = pkgsStatic.callPackage ../findent-octopus {};

    difftasticStatic = pkgsStatic.difftastic.overrideAttrs (oa: {
      env.RUSTFLAGS = (oa.env.RUSTFLAGS or "") + " -C relocation-model=static";
    });

  in {
    age = "${goLinkStatic pkgs.age {}}/bin/age";
    age-keygen = "${goLinkStatic pkgs.age {}}/bin/age-keygen";
    bat = "${pkgsStatic.bat}/bin/.bat-wrapped";
    bfs = "${bfsStatic}/bin/bfs";
    bsdcat = "${pkgsStatic.libarchive}/bin/bsdcat";
    bsdcpio = "${pkgsStatic.libarchive}/bin/bsdcpio";
    bsdtar = "${pkgsStatic.libarchive}/bin/bsdtar";
    btop = "${btopStatic}/bin/btop";
    bwrap = "${pkgsStatic.bubblewrap}/bin/bwrap";
    coreutils = "${pkgsStatic.coreutils}/bin/coreutils";
    croc = "${goLinkStatic pkgs.croc {}}/bin/croc";
    delta = "${pkgsStatic.delta}/bin/delta";
    difft = "${difftasticStatic}/bin/difft";
    direnv = "${goLinkStatic pkgs.direnv { BASH_PATH = ""; }}/bin/direnv";
    dive = "${goLinkStatic pkgs.dive {}}/bin/dive";
    fd = "${pkgsStatic.fd}/bin/fd";
    findent-octopus = "${findent-octopus}/bin/findent-octopus";
    fq = "${goLinkStatic pkgs.fq {}}/bin/fq";
    freeze = "${goLinkStatic pkgs.charm-freeze {}}/bin/freeze";
    fzf = "${goLinkStatic pkgs.fzf {}}/bin/fzf";
    gh = "${goLinkStatic pkgs.gh {}}/bin/gh";
    glab = "${goLinkStatic pkgs.glab {}}/bin/glab";
    gobuster = "${goLinkStatic pkgs.gobuster {}}/bin/gobuster";
    gocryptfs = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/.gocryptfs-wrapped";
    gocryptfs-xray = "${goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }}/bin/gocryptfs-xray";
    gotop = "${goLinkStatic pkgs.gotop {}}/bin/gotop";
    gotty = "${goLinkStatic pkgs.gotty {}}/bin/gotty";
    h5ls = "${pkgsStatic.hdf5.bin}/bin/h5ls";
    httm = "${pkgsStatic.httm}/bin/httm";
    hyperfine = "${pkgsStatic.hyperfine}/bin/hyperfine";
    jq = "${pkgsStatic.jq}/bin/jq";
    lemonade = "${goLinkStatic pkgs.lemonade {}}/bin/lemonade";
    less = "${pkgsStatic.less}/bin/less";
    libtree = "${pkgsStatic.libtree}/bin/libtree";
    lsof = "${pkgsStatic.lsof}/bin/lsof";
    mg = "${mgStatic}/bin/mg";
    micro = "${goLinkStatic pkgs.micro {}}/bin/micro";
    mtr = "${pkgsStatic.mtr}/bin/mtr";
    nc = "${pkgsStatic.netcat}/bin/nc";
    ncat = "${nmapStatic}/bin/ncat";
    ncdu = "${ncduStatic}/bin/ncdu";
    nmap = "${nmapStatic}/bin/nmap";
    nping = "${nmapStatic}/bin/nping";
    ox = "${pkgsStatic.ox}/bin/ox";
    par2 = "${pkgsStatic.par2cmdline}/bin/par2";
    patchelf = "${pkgsStatic.patchelf}/bin/patchelf";
    progress = "${pkgsStatic.progress}/bin/progress";
    pv = "${pkgsStatic.pv}/bin/pv";
    rclone = "${goLinkStatic pkgs.rclone {}}/bin/.rclone-wrapped";
    reptyr = "${pkgsStatic.reptyr.overrideAttrs (_: { doCheck = false; checkFlags = null; })}/bin/reptyr";
    restic = "${goLinkStatic pkgs.restic {}}/bin/.restic-wrapped";
    rg = "${ripgrepStatic}/bin/rg";
    rga = "${ripgrepAllStatic}/bin/rga";
    rga-preproc = "${ripgrepAllStatic}/bin/rga-preproc";
    ruff = "${ruffStatic}/bin/ruff";
    rustic = "${pkgsStatic.rustic-rs}/bin/rustic";
    sccache = "${pkgsStatic.sccache}/bin/sccache";
    sops = "${goLinkStatic sops {}}/bin/sops";
    sqlite3 = "${pkgsStatic.sqlite.override { interactive = true; }}/bin/sqlite3";
    ssh-to-age = "${goLinkStatic pkgs.ssh-to-age {}}/bin/ssh-to-age";
    subfinder = "${goLinkStatic pkgs.subfinder {}}/bin/subfinder";
    tmux = "${pkgsStatic.tmux}/bin/tmux";
    tree = "${pkgsStatic.tree}/bin/tree";
    ts = "${pkgsStatic.taskspooler}/bin/.ts-wrapped";
    tspin = "${pkgsStatic.tailspin}/bin/tspin";
    ug = "${ugrepStatic}/bin/ug";
    unison = "${unisonStatic}/bin/unison";
    unison-fsmonitor = "${unisonStatic}/bin/unison-fsmonitor";
    upterm = "${goLinkStatic pkgs.upterm {}}/bin/upterm";
    uv = "${pkgsStatic.uv}/bin/uv";
    watchexec = "${pkgsStatic.watchexec}/bin/watchexec";
    wireproxy = "${goLinkStatic pkgs.wireproxy {}}/bin/wireproxy";
    wormhole-william = "${goLinkStatic pkgs.wormhole-william {}}/bin/wormhole-william";
    zstd = "${pkgsStatic.zstd}/bin/zstd";
  };

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
  in {
    "lesspipe.sh" = "${lesspipe'}/bin/lesspipe.sh";
  };

  copyBinaries = lib.attrsets.mapAttrsToList (dst: src: ''
    2>&1 ${pkgs.binutils}/bin/readelf -x .interp ${lib.escapeShellArg "${src}"} |
      tee /dev/stderr | grep -qF "Warning: Section '.interp' was not dumped because it does not exist"
    ln -sv ${lib.escapeShellArg "${src}"} $out/bin/${dst}
  '') binaries;

  copyScripts = lib.attrsets.mapAttrsToList (dst: src: ''
    grep -F '/nix/store' "${src}" && exit 1
    ln -sv ${lib.escapeShellArg "${src}"} $out/bin/${dst}
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
