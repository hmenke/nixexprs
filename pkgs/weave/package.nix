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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V2QlOoLbQhmrdy8MWFZnB+t60oBtPsNci7I0FWkVnrI=";
  };

  cargoHash = "sha256-/Zm9ZoS5deX/CAao3grl+cFW7rqeAzi/jyzuktjvbLc=";

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
