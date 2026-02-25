{ lib
, stdenv
, fetchFromGitLab
, bison
, flex
}:

stdenv.mkDerivation (final: {
  pname = "findent-octopus";
  version = "1.0-unstable-2026-02-20";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "findent-octopus";
    rev = "5432c71402157515564b91507616780fb933f3ae";
    hash = "sha256-6EZHA6UNFRFsq2avE9Al+PHdu9HfONcBNKLiCGN0le0=";
  };

  nativeBuildInputs = [ bison flex ];

  makeFlags = [ "-C bin" "CPP=$(CXX)" ];

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
