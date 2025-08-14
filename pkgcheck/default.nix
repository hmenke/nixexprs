{
  lib,
  fetchFromGitea,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pkgcheck";
  version = "3.3.0_2025-06-01";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ManfredLotz";
    repo = "pkgcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+/ZQAhmw1dEs3AomgYNmc6wtdkW7NYyXfGW+RaPkruA=";
  };

  cargoHash = "sha256-1RrKJqNBC0cNLHhXwpyuxeFpvslORRwBzHxAEjHgK0s=";

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
