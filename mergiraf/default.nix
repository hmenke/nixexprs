{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mergiraf";
  version = "0.16.3-unstable-2026-05-04";

  src = fetchFromCodeberg {
    owner = "mergiraf";
    repo = "mergiraf";
    rev = "ac75c1e8667ceae8938bc7fde9f7066f785fa8c1";
    hash = "sha256-HZBvbtSdu1ruz2FR+pMR8sghLUf2GsE+y2GhlHiPHVc=";
  };

  cargoHash = "sha256-WHSs46wVei24XF971QLOY5vrzdj1ndw4lXVZo6oUB2E=";

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
