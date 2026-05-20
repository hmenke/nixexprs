{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "denet";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "btraven00";
    repo = "denet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bBSVp0GBa8gct8eE0NlrpF1063Z8wkVJercCamfPGD8=";
  };

  cargoHash = "sha256-87/ETHOgymxyXSQxFaR/eacjQUXAPoW4N49eFrclIik=";

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
