{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "redu";
  version = "0.2.10";

  env = {
    # redu depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    rev = "refs/tags/v${version}";
    hash = "sha256-zZkwfO8T9k73eHXkocXQK6qegCYZJHWOjI/73hMXq4o=";
  };

  cargoHash = "sha256-lPiMJxqyplo9tZknwL9SLWAuWpvFF9SottI+R91vSp0=";

  meta = {
    homepage = "https://github.com/drdo/redu";
    description = "ncdu for your restic repository";
    mainProgram = "redu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
  };
}
