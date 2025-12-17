{
  lib,
  fetchFromGitea,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pkgcheck";
  version = "3.3.1_2025-12-11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ManfredLotz";
    repo = "pkgcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sFQk3Y9skvvVs/R7qjB53cio6mFMAuWOwjylLXt/RnE=";
  };

  cargoHash = "sha256-OeW6c27W3hif87kIV9mSSx04FmXvNUftiRmNEz/UKSY=";

  meta = {
    description = "Command line utility which the author uses to check uploaded packages to CTAN before installing them";
    homepage = "https://codeberg.org/ManfredLotz/pkgcheck";
    changelog = "https://codeberg.org/ManfredLotz/pkgcheck/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "pkgcheck";
  };
})
