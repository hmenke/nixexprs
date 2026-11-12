{
  aws-lc,
  fetchFromGitHub,
  gitMinimal,
  lib,
  libgit2,
  openssl,
  pkg-config,
  rustPlatform,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "weave";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "weave";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zxW4uDjZsL7a6jxbNOIuy1XWGZP/oEZ0Z2k0xYBxRvE=";
  };

  cargoHash = "sha256-9AoA7d97xwBCzdxhDtZqhPqPItFfcf2+zZpCdk3CGi4=";

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    aws-lc
    libgit2
    openssl
  ];
  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];
  preCheck = ''
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
  '';
  checkFlags = [
    "--exact"
    "--skip=a_commit_that_fails_on_a_lock_then_a_removed_lock_never_publishes_a_merge_that_drops_main"
  ];
  cargoTestFlags = [
    "--no-fail-fast"
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
