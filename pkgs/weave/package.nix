{
  lib,
  fetchFromGitHub,
  gitMinimal,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "weave";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-en8HwzvC2uPBwyHnQyUHrRLvWyWDWPptfTpX353i/pU=";
  };

  cargoHash = "sha256-LYcHCc3OkBmWY9tSpm3Mp+Dw/CRoTICngL7+GkUDAHk=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];
  nativeCheckInputs = [
    gitMinimal
  ];

  meta = {
    description = "Entity-level semantic merge driver for Git";
    homepage = "https://ataraxy-labs.github.io/weave";
    changelog = "https://github.com/Ataraxy-Labs/weave/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "weave-cli";
  };
})
