{
  lib,
  fetchFromGitea,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "pkgcheck";
  version = "4.1.2_2026-10-07";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ManfredLotz";
    repo = "pkgcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tL+0YHSC1wq9qi5lEKm6Cy4FwwuinUM8/UuRZiAy/xc=";
  };

  cargoHash = "sha256-Be+jESYIqXX9/hHLGII/T/NOEOkILpSpyywCRGC+kcA=";

  checkFlags = [
    "--skip=setgid_file_flagged"
    "--skip=setuid_and_setgid_both_collapse_to_one_issue"
    "--skip=setuid_file_flagged"
    "--skip=setuid_on_directory_not_flagged"
  ];

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
