{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "mergiraf";
  version = "0.17.0-unstable-2026-05-07";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "11b88160fb47376d5b27d524cbed5daebfa0c997";
    hash = "sha256-Tqz1gNg2XIYO/dFETajF3XUs3A1+mY82U4pz+mMb/ws=";
  };

  cargoHash = "sha256-8Geu6Cd83hTnd53/ZTKq1YIEMIX4oIgwzSS6h8RNaP8=";

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
