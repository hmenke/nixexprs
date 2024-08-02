{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "redu";
  version = "0.2.3";

  env = {
    # redu depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    rev = "refs/tags/v${version}";
    hash = "sha256-51kHAAkA32GInSTDPl0GlEdG5Xl3oZXeJH3WZmFuF4w=";
  };

  cargoHash = "sha256-taXeSur1F5niIbip9OerprYBa5iUkZCZ35hgH427gSE=";

  meta = {
    homepage = "https://github.com/drdo/redu";
    description = "ncdu for your restic repository";
    mainProgram = "redu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
  };
}
