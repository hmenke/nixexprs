{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "denet";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "btraven00";
    repo = "denet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QNd/4AU+VrXf94RJdMGE2MAfmr26pvmqvINckH2ZhTA=";
  };

  cargoHash = "sha256-2aUyRqQrxcSyUCAaqVFAmNQnTblyoxs9vI44j3I1UTM=";

  doCheck = false; # TODO

  meta = {
    description = "Streaming process monitoring tool that provides detailed metrics on running processes, including CPU, memory, I/O, and thread usage";
    homepage = "https://github.com/btraven00/denet";
    changelog = "https://github.com/btraven00/denet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "denet";
  };
})
