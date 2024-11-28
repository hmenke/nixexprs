{ fetchFromGitHub
, lib
, makeWrapper
, python3
, stdenv
, valgrind
}:

let
  verrou = fetchFromGitHub {
    owner = "edf-hpc";
    repo = "verrou";
    rev = "v2.6.0";
    hash = "sha256-TSPJp6PWboo2xjl7oP4O0RH2X7uQuAYQAIExulUQ4u4=";
  };
in
valgrind.overrideAttrs (oa: rec {
  pname = "verrou";
  version = "2.6.0";
  name = "${oa.pname}-${oa.version}+${pname}-${version}";

  patches = (oa.patches or []) ++ [
    (verrou + "/valgrind.arm64.diff")
    (verrou + "/valgrind.diff")
    (verrou + "/valgrind.fma_arm64.diff")
  ];

  postPatch = ''
    cp -rv --no-preserve=all ${verrou} verrou
  '';

  nativeBuildInputs = (oa.nativeBuildInputs or []) ++ [ makeWrapper ];
  buildInputs = (oa.buildInputs or []) ++ [ python3 ];

  NIX_ENFORCE_NO_NATIVE = false;

  postInstall = ''
    . $out/env.sh
    rm $out/env.sh
    for f in $(find $out/bin -type f -executable); do
      wrapProgram "$f" \
        --set-default VERROU_COMPILED_WITH_FMA $VERROU_COMPILED_WITH_FMA \
        --set-default VERROU_COMPILED_WITH_QUAD $VERROU_COMPILED_WITH_QUAD
    done
  '';
})
