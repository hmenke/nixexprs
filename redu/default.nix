{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redu";
  version = "0.2.13";

  env = {
    # redu depends on nightly features
    RUSTC_BOOTSTRAP = 1;
  };

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iea3tt1WB0/5XPNeCAk38/UoCHVSngXfNmfZQyspmsw=";
  };

  postPatch = ''
    sed -i"" -e '1i #![feature(char_min)]' src/lib.rs
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-fiMZIFIVeFnBnRBgmdUB8E5A2pM5nrTfUgD1LS6a4LQ=";

  meta = {
    homepage = "https://github.com/drdo/redu";
    description = "ncdu for your restic repository";
    mainProgram = "redu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
  };
})
