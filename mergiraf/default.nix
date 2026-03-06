{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.16.3-unstable-2026-03-01";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "eaf71aeec3ace2f7b57b1441b97b989fd152898b";
    hash = "sha256-Ga4ixNuOtthfgp5lB3XniHZ3lauVb3B51wtHv644ThY=";
  };

  cargoHash = "sha256-cNtkvUpKHzLisGiABxSoidXLgxhIdieDZZeNaFCwiD0=";

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
