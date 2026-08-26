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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Aj2fWvur1N2VnVlPJHqg0L5hiWGdthznkTvIzWgGlIg=";
  };

  cargoHash = "sha256-erodWNZ/E50ND2F1UXSYd5LXi8A4EIaUNoJYld6KJjQ=";

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
