{
  lib,
  stdenv,
  fetchFromGitLab,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "findent-octopus";
  version = "1.0-unstable-2026-11-17";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "findent-octopus";
    rev = "e4b23370f962fee093543cb25ba183d483d566ce";
    hash = "sha256-QuvERrYQ0xXb8yA/mKlXHxbhja9J46z5yiEj/ifklow=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  makeFlags = [
    "-C"
    "bin"
    "CPP=$(CXX)"
  ];

  installPhase = ''
    install -D -m755 ./bin/findent-octopus $out/bin/findent-octopus
    install -D -m755 ./scripts/findent-octopus_batch $out/bin/findent-octopus_batch
  '';

  meta = {
    description = "findent-octopus indents/beautifies/converts Fortran sources.";
    homepage = "https://gitlab.com/octopus-code/findent-octopus";
    license = lib.licenses.bsd3;
    mainProgram = "findent-octopus";
    maintainers = with lib.maintainers; [ hmenke ];
  };
})
