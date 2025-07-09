{ lib
, stdenv
, fetchFromGitLab
, bison
, flex
}:

stdenv.mkDerivation (final: {
  pname = "findent-octopus";
  version = "1.0-unstable-2025-06-29";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "findent-octopus";
    rev = "555c51f2f803ed756fd36e98552a1417e4d599cf";
    hash = "sha256-Sz73cnhYuSfXBQ7UdRsfPJfctDFN64bAqHtxnboNK4Q=";
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
