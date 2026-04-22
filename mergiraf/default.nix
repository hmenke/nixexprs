{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.16.3-unstable-2026-04-20";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "b93e8c524414459e4bad8eb2e625b46ecac187db";
    hash = "sha256-Z6+nI6OCmk53llWKtyQ0lAFVC1t2UFjmw95s6iR8x2w=";
  };

  cargoHash = "sha256-AaReikxGMcRWen6p7+0eMdJOOMaMH4xJVzMQzt1uRLE=";

  nativeCheckInputs = [ git ];

  cargoBuildFlags = [
    # don't install the `mgf_dev`
    "--bin"
    "mergiraf"
  ];

  checkFlags = [ "--skip=test::solve_respects_conflict_marker_size_attr" ];

  meta = {
    description = "Syntax-aware git merge driver for a growing collection of programming languages and file formats";
    homepage = "https://mergiraf.org/";
    downloadPage = "https://codeberg.org/mergiraf/mergiraf";
    changelog = "https://codeberg.org/mergiraf/mergiraf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "mergiraf";
  };
})
