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
    rev = "2c871e7c73516100b9509474432557be97619267";
    hash = "sha256-a8WFaNEMij6qP7U9bA2uCGAFOAcivmf8MR1WePWyl50=";
  };
in
valgrind.overrideAttrs (oa: rec {
  pname = "verrou";
  version = "unstable-2024-03-29";
  name = "${oa.pname}-${oa.version}+${pname}-${version}";

  patches = (oa.patches or []) ++ [
    (verrou + "/valgrind.arm64.diff")
    (verrou + "/valgrind.diff")
    (verrou + "/valgrind.fma_amd64.diff")
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
