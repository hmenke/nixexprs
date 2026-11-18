{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "pandoc-bin";
  version = "3.14";

  src = fetchurl {
    url = "https://github.com/jgm/pandoc/releases/download/${finalAttrs.version}/pandoc-${finalAttrs.version}-linux-amd64.tar.gz";
    hash = "sha256-xfRyDN77P3vcXQcgLvV5/u8NE3B3PIc4BN2P2qjE8bg=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    mkdir -pv $out/bin $out/share/man/man1
    install -v -D -m 0755 -t $out/bin bin/pandoc
    ln -v -s pandoc $out/bin/pandoc-server
    ln -v -s pandoc $out/bin/pandoc-lua
    install -v -D -m 0644 -t $out/share/man/man1 share/man/man1/*
  '';
})
