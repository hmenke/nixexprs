{ ... }@args:

let
  pkgs =
    let
      _pkgs = args.pkgs or (import <nixpkgs> { });
    in
    _pkgs.appendOverlays [
      (
        final: prev:
        _pkgs.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (prev) callPackage newScope;
          directory = ../pkgs;
        }
      )
      (
        final: prev:
        let
          lib = prev.lib;
          isStatic = prev.stdenv.hostPlatform.isStatic;
        in
        {
          ### start of overlay ###

          unison =
            if !isStatic then
              prev.unison
            else
              (prev.pkgsBuildHost.pkgsMusl.unison.override { enableX11 = false; }).overrideAttrs {
                LDFLAGS = "-static";
              };

          bfs = prev.bfs.overrideAttrs (
            oa:
            lib.optionalAttrs (isStatic && lib.versionOlder lib.version "26") {
              configurePhase = ''
                runHook preConfigure
                ./configure --prefix=$out --enable-release
                runHook postConfigure
              '';
            }
          );

          ripgrep-all = prev.ripgrep-all.overrideAttrs (
            oa:
            lib.optionalAttrs isStatic {
              doCheck = false;
              nativeCheckInputs = null;
              postInstall = null;
            }
          );

          btop = prev.btop.overrideAttrs (
            oa:
            lib.optionalAttrs (isStatic && lib.versionOlder lib.version "26") {
              hardeningDisable = (oa.hardeningDisable or [ ]) ++ [
                "fortify"
              ];
              cmakeFlags = (oa.cmakeFlags or [ ]) ++ [
                "-DBTOP_STATIC:BOOL=ON"
                "-DBTOP_FORTIFY:BOOL=OFF"
              ];
            }
          );

          liblinear = prev.liblinear.overrideAttrs (
            oa:
            lib.optionalAttrs isStatic {
              patches = (oa.patches or [ ]) ++ [ ./0002-liblinear-static.patch ];
              installPhase = ''
                install -Dt $out/lib liblinear.a
                install -D train $bin/bin/liblinear-train
                install -D predict $bin/bin/liblinear-predict
                install -Dm444 -t $dev/include linear.h
              '';
            }
          );

          nmap =
            if !isStatic then
              prev.nmap
            else
              (prev.nmap.override {
                withLua = false;
              }).overrideAttrs
                (oa: {
                  configureFlags = (oa.configureFlags or [ ]) ++ [
                    "--without-libnl"
                  ];
                });

          mg = prev.mg.overrideAttrs (oa: {
            patches =
              assert (oa.patches or [ ]) == [ ];
              [
                (prev.fetchpatch {
                  name = "Add-Ctrl-arrow-Ctrl-PgUp-Dn-to-fundamental-bindings.patch";
                  url = "https://github.com/troglobit/mg/commit/4a1ddb3aa158a9e2d8281427972debc6d326a2f8.patch";
                  hash = "sha256-TxAO9gJGUoHgnC6IJpkq2Cx5evV3UVgHIsokLwetlg4=";
                })
              ];
            patchFlags = [
              "-p2"
              "-F3"
            ];
          });

          universal-ctags =
            if !isStatic then
              prev.universal-ctags
            else
              (prev.universal-ctags.override {
                python3 = prev.pkgsBuildHost.python3;
              }).overrideAttrs
                (_: {
                  doCheck = false;
                });

          vtm = prev.vtm.overrideAttrs (
            oa:
            lib.optionalAttrs isStatic {
              patches = (oa.patches or [ ]) ++ [
                ./0003-vtm-musl.patch
              ];
            }
          );

          patchelf = prev.patchelf.overrideAttrs (
            oa:
            lib.optionalAttrs isStatic {
              doCheck = false;
            }
          );

          htop = prev.htop.override (
            lib.optionalAttrs (isStatic && lib.versionOlder lib.version "26") {
              sensorsSupport = false;
            }
          );

          libutempter = prev.libutempter.overrideAttrs (
            oa:
            lib.optionalAttrs (isStatic && lib.versionOlder lib.version "26") {
              makeFlags = [
                "utempter"
                "libutempter.a"
              ]
              ++ (oa.makeFlags or [ ]);
              preInstall = ''
                touch libutempter.so
              '';

              postInstall = ''
                rm -v $out/lib/libutempter.so*
              '';
            }
          );

          tmux = prev.tmux.override {
            withUtempter = true;
          };

          charm-freeze = prev.charm-freeze.overrideAttrs (oa: {
            patches = (oa.patches or [ ]) ++ [
              (prev.fetchpatch {
                name = "fix-Support-bold-ANSI-escape-sequence.patch";
                url = "https://github.com/charmbracelet/freeze/pull/154/commits/a35b9da282154c6a88550a68e130a5b161645ebc.patch";
                hash = "sha256-bgoKLYiTFIktE5YqXwd9TmcQIcBsWNQAo5cHVj3qtlU=";
              })
            ];
            doCheck = false; # tests including bold of course fail now
          });

          direnv = prev.direnv.overrideAttrs (
            oa:
            if oa ? "BASH_PATH" then
              { BASH_PATH = ""; }
            else
              {
                env = (oa.env or { }) // {
                  BASH_PATH = "";
                };
              }
          );

          mosh =
            if !isStatic then
              prev.mosh
            else
              (prev.mosh.override {
                inherit (prev.pkgsBuildHost) perl openssh;
                withUtempter = true;
              }).overrideAttrs
                (oa: {
                  patches = (oa.patches or [ ]) ++ [
                    ./mosh-fix-colors.patch
                    ./mosh-fix-username.patch
                  ];
                  postPatch = ''
                    substituteInPlace scripts/mosh.pl \
                      --subst-var-by ssh "ssh" \
                      --subst-var-by mosh-client "mosh-client"
                  '';
                  postInstall = "";
                  dontPatchShebangs = true;
                });

          libwebsockets = prev.libwebsockets.overrideAttrs (
            oa:
            lib.optionalAttrs (isStatic && lib.versionOlder lib.version "26") {
              postPatch = (oa.postPatch or "") + ''
                substituteInPlace "cmake/libwebsockets-config.cmake.in" --replace-warn \
                  "set(LIBWEBSOCKETS_LIBRARIES websockets websockets_shared)" \
                  "set(LIBWEBSOCKETS_LIBRARIES websockets)"
              '';
            }
          );

          vhs = prev.vhs.overrideAttrs (oa: {
            postInstall = ''
              $out/bin/vhs man > vhs.1
              installManPage vhs.1
              installShellCompletion --cmd vhs \
                --bash <($out/bin/vhs completion bash) \
                --fish <($out/bin/vhs completion fish) \
                --zsh <($out/bin/vhs completion zsh)
            '';
          });

          reptyr = prev.reptyr.overrideAttrs (
            _:
            lib.optionalAttrs (isStatic && lib.versionOlder lib.version "26") {
              doCheck = false;
              checkFlags = null;
            }
          );

          gh = prev.gh.overrideAttrs (
            oa:
            lib.optionalAttrs (lib.versionOlder lib.version "26") {
              nativeBuildInputs = (oa.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
              postInstall = (oa.postInstall or "") + ''
                wrapProgram $out/bin/gh --set-default GH_TELEMETRY false
              '';
            }
          );

          lesspipe' = prev.stdenv.mkDerivation {
            name = prev.lesspipe.name;
            src = prev.lesspipe.src;
            meta = prev.lesspipe.meta;
            nativeBuildInputs = [ prev.perl ];
            configureFlags = [ "--prefix=/" ];
            configurePlatforms = [ ];
            dontBuild = true;
            installFlags = [ "DESTDIR=$(out)" ];
            dontPatchShebangs = true;
          };

          ### end of overlay ###
        }
      )
    ];

  goLinkStatic =
    drv: args:
    drv.overrideAttrs (
      oa:
      pkgs.lib.recursiveUpdate {
        env = (oa.env or { }) // {
          CGO_ENABLED = 0;
        };
        ldflags = (oa.ldflags or [ ]) ++ [
          "-s"
          "-w"
          "-extldflags '-static'"
        ];
      } (if pkgs.lib.isFunction args then args oa else args)
    );
in
with pkgs;

let
  binaries = {
    age = "${goLinkStatic pkgs.age { }}/bin/age";
    age-keygen = "${goLinkStatic pkgs.age { }}/bin/age-keygen";
    archivemount = "${pkgsStatic.archivemount}/bin/archivemount";
    bat = "${pkgsStatic.bat}/bin/.bat-wrapped";
    bfs = "${pkgsStatic.bfs}/bin/bfs";
    bsdcat = "${pkgsStatic.libarchive}/bin/bsdcat";
    bsdcpio = "${pkgsStatic.libarchive}/bin/bsdcpio";
    bsdtar = "${pkgsStatic.libarchive}/bin/bsdtar";
    btdu = "${pkgs.btdu-static}/bin/btdu";
    btop = "${pkgsStatic.btop}/bin/btop";
    busybox = "${pkgsStatic.busybox}/bin/busybox";
    bwrap = "${pkgsStatic.bubblewrap}/bin/bwrap";
    coreutils = "${pkgsStatic.coreutils}/bin/coreutils";
    cpz = "${pkgsStatic.fuc}/bin/cpz";
    ctags = "${pkgsStatic.universal-ctags}/bin/ctags";
    delta = "${pkgsStatic.delta}/bin/delta";
    denet = "${pkgsStatic.denet}/bin/denet";
    difft = "${pkgsStatic.difftastic}/bin/difft";
    direnv = "${goLinkStatic pkgs.direnv { }}/bin/direnv";
    dive = "${goLinkStatic pkgs.dive { }}/bin/dive";
    fd = "${pkgsStatic.fd}/bin/fd";
    findent-octopus = "${pkgsStatic.findent-octopus}/bin/findent-octopus";
    fq = "${goLinkStatic pkgs.fq { }}/bin/fq";
    freeze = "${goLinkStatic pkgs.charm-freeze { }}/bin/freeze";
    fuse2fs = "${pkgsStatic.fuse2fs}/bin/fuse2fs";
    fzf = "${goLinkStatic pkgs.fzf { }}/bin/fzf";
    gh = "${goLinkStatic pkgs.gh { }}/bin/.gh-wrapped";
    glab = "${goLinkStatic pkgs.glab { }}/bin/.glab-wrapped";
    gocryptfs = "${
      goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }
    }/bin/.gocryptfs-wrapped";
    gocryptfs-xray = "${
      goLinkStatic pkgs.gocryptfs { tags = [ "without_openssl" ]; }
    }/bin/gocryptfs-xray";
    gotop = "${goLinkStatic pkgs.gotop { }}/bin/gotop";
    gotty = "${goLinkStatic pkgs.gotty { }}/bin/gotty";
    h5ls = "${pkgsStatic.hdf5.bin}/bin/h5ls";
    htop = "${pkgsStatic.htop}/bin/htop";
    httm = "${pkgsStatic.httm}/bin/httm";
    hyperfine = "${pkgsStatic.hyperfine}/bin/hyperfine";
    jj = "${pkgsStatic.jujutsu}/bin/jj";
    jq = "${pkgsStatic.jq}/bin/jq";
    lemonade = "${goLinkStatic pkgs.lemonade { }}/bin/lemonade";
    less = "${pkgsStatic.less}/bin/less";
    libtree = "${pkgsStatic.libtree}/bin/libtree";
    lsof = "${pkgsStatic.lsof}/bin/lsof";
    mergiraf = "${pkgsStatic.mergiraf}/bin/mergiraf";
    mg = "${pkgsStatic.mg}/bin/mg";
    mosh-server = "${pkgsStatic.mosh}/bin/mosh-server";
    mtr = "${pkgsStatic.mtr}/bin/mtr";
    nc = "${pkgsStatic.netcat}/bin/nc";
    ncat = "${pkgsStatic.nmap}/bin/ncat";
    ncdu = "${pkgs.ncdu-static}/bin/ncdu";
    nmap = "${pkgsStatic.nmap}/bin/nmap";
    nping = "${pkgsStatic.nmap}/bin/nping";
    ntfy-send = "${goLinkStatic pkgs.ntfy-send { }}/bin/ntfy-send";
    par2 = "${pkgsStatic.par2cmdline}/bin/par2";
    patchelf = "${pkgsStatic.patchelf}/bin/patchelf";
    progress = "${pkgsStatic.progress}/bin/progress";
    pv = "${pkgsStatic.pv}/bin/pv";
    rclone = "${goLinkStatic pkgs.rclone { }}/bin/.rclone-wrapped";
    readtags = "${pkgsStatic.universal-ctags}/bin/readtags";
    rederr = "${pkgsStatic.rederr}/bin/rederr";
    reptyr = "${pkgsStatic.reptyr}/bin/reptyr";
    restic = "${goLinkStatic pkgs.restic { }}/bin/.restic-wrapped";
    rg = "${pkgsStatic.ripgrep}/bin/rg";
    rga = "${pkgsStatic.ripgrep-all}/bin/rga";
    rga-preproc = "${pkgsStatic.ripgrep-all}/bin/rga-preproc";
    rmz = "${pkgsStatic.fuc}/bin/rmz";
    ruff = "${pkgsStatic.ruff}/bin/ruff";
    rustic = "${pkgsStatic.rustic}/bin/rustic";
    sccache = "${pkgsStatic.sccache}/bin/sccache";
    sd = "${pkgsStatic.sd}/bin/sd";
    sops = "${goLinkStatic pkgs.sops { }}/bin/sops";
    sqlite3 = "${pkgsStatic.sqlite-interactive}/bin/sqlite3";
    ssh-to-age = "${goLinkStatic pkgs.ssh-to-age { }}/bin/ssh-to-age";
    tmux = "${pkgsStatic.tmux}/bin/tmux";
    toybox = "${pkgsStatic.toybox}/bin/toybox";
    tree = "${pkgsStatic.tree}/bin/tree";
    ttyd = "${pkgsStatic.ttyd}/bin/ttyd";
    ts = "${pkgsStatic.taskspooler}/bin/.ts-wrapped";
    ug = "${pkgsStatic.ugrep}/bin/ug";
    unison = "${pkgsStatic.unison}/bin/unison";
    unison-fsmonitor = "${pkgsStatic.unison}/bin/unison-fsmonitor";
    upterm = "${goLinkStatic pkgs.upterm { }}/bin/upterm";
    uv = "${pkgsStatic.uv}/bin/uv";
    vhs = "${goLinkStatic pkgs.vhs { }}/bin/vhs";
    vtm = "${pkgsStatic.vtm}/bin/vtm";
    watchexec = "${pkgsStatic.watchexec}/bin/watchexec";
    wireproxy = "${goLinkStatic pkgs.wireproxy { }}/bin/wireproxy";
    zstd = "${pkgsStatic.zstd}/bin/zstd";
  };

  scripts = {
    "lesspipe.sh" = "${lesspipe'}/bin/lesspipe.sh";
  };

  share = pkgs.buildEnv {
    name = "local-share";
    paths = lib.lists.flatten (
      lib.mapAttrsToList (
        _: path: lib.mapAttrsToList (drvPath: _: (import drvPath).all) (builtins.getContext path)
      ) (lib.filterAttrs (name: _: !lib.elem name [ "jj" ]) (binaries // scripts))
    );
    pathsToLink = [
      "/share/bash-completion"
      "/share/btop"
      "/share/fzf"
    ];
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

  copyShare = map (path: ''
    grep -RF '/nix/store' "${share}/${path}" && exit 1
    mkdir -p "$(dirname "$out/${path}")"
    cp -PRv ${lib.escapeShellArg "${share}/${path}"} $out/${path}
  '') share.pathsToLink;

  gitMinimalStatic = pkgsStatic.gitMinimal.overrideAttrs (oa: {
    doInstallCheck = false;
    # force detection of curl
    configureFlags = oa.configureFlags or [ ] ++ [
      "ac_cv_lib_curl_curl_global_init=yes"
    ];
    # undo patchShebangs and substitutions
    postFixup = oa.postFixup or "" + ''
      find $out -type f -exec grep -Iq . {} \; -print0 |
        xargs -0 -l -t sed -i 's%#!/nix/store/[[:graph:]]*%#!/bin/sh%g; s%/nix/store/[^/]*/bin/\([[:graph:]]*\)%\1%g'
    '';
    # libidn2 also defines `error'
    env.LDFLAGS = (oa.env.LDFLAGS or "") + " -z muldefs";
  });

in
pkgs.stdenvNoCC.mkDerivation {
  name = "local-bin";
  phases = [
    "installPhase"
    "fixupPhase"
  ];
  dontPatchShebangs = true;
  installPhase = ''
    mkdir -p $out/bin $out/libexec $out/share
    ${lib.concatStrings copyBinaries}
    ${lib.concatStrings copyScripts}
    ${lib.concatStrings copyShare}
    ln -s ${gitMinimalStatic}/libexec/git-core $out/libexec/git-core
  '';
}
