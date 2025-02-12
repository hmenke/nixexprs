{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "redu";
  version = "0.2.11";

  env = {
    # redu depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    rev = "refs/tags/v${version}";
    hash = "sha256-6S61PyZLHB/iI9q1qxZq7eVuUMwcF/uCgCAyjJZNm5E=";
  };

  cargoHash = "sha256-WioF3G8syU2smwMe90Bv9Hsm9nLJtCoRUcrcujGiCws=";

  meta = {
    homepage = "https://github.com/drdo/redu";
    description = "ncdu for your restic repository";
    mainProgram = "redu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
  };
}
