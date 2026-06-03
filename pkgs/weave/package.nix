{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "weave";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yTfgDpbTWVEf8qe91RmAx4QjixDcbrw8GMKJN+oPfsk=";
  };

  cargoHash = "sha256-UUTLlr1ohqnXDK+ADZxIWqVMF5HHZ6a73KYwFDV5O7Q=";

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
