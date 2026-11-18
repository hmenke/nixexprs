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
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "btraven00";
    repo = "denet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OGwsrkKWN1wwgQl7O3kxy7mE+OzHWlU+NySfCJVr9SQ=";
  };

  cargoHash = "sha256-chp0uWYvvZyg0ajKBIgvXQqTzPOc9pI43DSKDbs3BK4=";

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
