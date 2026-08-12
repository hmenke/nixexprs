{
  lib,
  fetchFromGitea,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "pkgcheck";
  version = "4.1.0_2026-08-05";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ManfredLotz";
    repo = "pkgcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NrpV9qUFXmRvCVO1Cpgz6qSPTMRGXX460RcH7JOYW/I=";
  };

  cargoHash = "sha256-xqxJOAyeaKjFu1cszRMM9+jKJgsHEf0utDHfGFj1v6A=";

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
