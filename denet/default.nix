{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "denet";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "btraven00";
    repo = "denet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+ZjOz0xf0F76QIQKcqXANqVm7SBirUT32HagSwXrJX8=";
  };

  cargoHash = "sha256-Lf5wdSo0VfFLRlvg05kjm3kDiIF1k3WQXhGB0UvbDDE=";

  doCheck = false; # TODO

  meta = {
    description = "Streaming process monitoring tool that provides detailed metrics on running processes, including CPU, memory, I/O, and thread usage";
    homepage = "https://github.com/btraven00/denet";
    changelog = "https://github.com/btraven00/denet/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "denet";
  };
})
