{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "denet";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "btraven00";
    repo = "denet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E9G3hrNE0OczAvGZtITneNYi1AD50qTSZhIJQVQLK/A=";
  };

  cargoHash = "sha256-ChzRmH31H5Goq751B7+wSHjkJriBJ7YP8Bn2MY55I+Y=";

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
