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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GKSINiu98bTYjspHqv/6b7VfCI00gfTkhrmlz0PEKk8=";
  };

  cargoHash = "sha256-FoewhLvXTZZYEcNlvjfqHMF87WP5Q8OzHmetep+qh/c=";

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
