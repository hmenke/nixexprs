{
  lib,
  fetchFromGitHub,
  python3,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "denet";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "btraven00";
    repo = "denet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E9G3hrNE0OczAvGZtITneNYi1AD50qTSZhIJQVQLK/A=";
  };

  cargoHash = "sha256-ChzRmH31H5Goq751B7+wSHjkJriBJ7YP8Bn2MY55I+Y=";

  buildFeatures = [ "gpu" ];

  nativeCheckInputs = [ python3 ];
  checkFlags = [
    # TODO: Why does this test fail?
    "--skip=metadata_reports_command_not_stub"
    # TODO: These only fail on nixpkgs-unstable and only in GitHub Actions
    "--skip=real_subprocesses_are_still_detected"
    "--skip=tree_energy_follows_tree_cpu"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Streaming process monitoring tool that provides detailed metrics on running processes, including CPU, memory, I/O, and thread usage";
    homepage = "https://github.com/btraven00/denet";
    changelog = "https://github.com/btraven00/denet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "denet";
  };
})
