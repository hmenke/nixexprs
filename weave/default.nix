{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weave";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+y40NBWwiZvG4x+v1aE+aCnoHT6+jXfYhZrALp8fK68=";
  };

  cargoHash = "sha256-wo4+Dpm1UROvY0C7LC8D6igO+4kNIWErb/ZDcXoenNc=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  meta = {
    description = "Entity-level semantic merge driver for Git";
    homepage = "https://ataraxy-labs.github.io/weave";
    changelog = "https://github.com/btraven00/denet/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "weave-cli";
  };
})
