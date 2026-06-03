{
  lib,
  fetchFromGitea,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "pkgcheck";
  version = "4.0.3_2026-05-28";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ManfredLotz";
    repo = "pkgcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DDb+t8zkV0soQwzWIvD/5IrJW1jyqp92Qkga2ok5O8k=";
  };

  cargoHash = "sha256-Oxl8sO9Y5ddudoWC8RltTO52mBdaG/Hxlp5FTQr4biU=";

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
