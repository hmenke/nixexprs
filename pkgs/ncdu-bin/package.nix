{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "ncdu-bin";
  version = "2.9.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-DGyEs/djwzuqBRyDJ/DnNvRvM6jMBhu5UdJFF6jF1z4=";
  };

  sourceRoot = ".";

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = "install -v -Dt $out/bin ncdu";
})
