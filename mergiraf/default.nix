{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.16.3-unstable-2026-04-03";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "9d896595bbae2a6cc4c7df680f400631314bd646";
    hash = "sha256-rB3+nNJjEBwHihsrfVkLzlIjGS+K/uv/NBG7T0hn2Yc=";
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
