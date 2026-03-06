{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.67.0-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "d7dcb61f785eba805a58329d3caa1107b5bd2f68";
    hash = "sha256-c4i4iEH2PpxoAcUdgx3N7/SIROjPrEumCByYmvlxmbI=";
  };

  cargoHash = "sha256-sJv1y1vs5XhixOMgEf9qchMFhKsJXErdWQN91BPMO7s=";

  buildInputs = [ rust-jemalloc-sys ];

  env = lib.optionalAttrs stdenv.hostPlatform.isStatic { RUSTFLAGS = "-C relocation-model=static"; };

  checkFlags = [ "--skip=options::tests::test_detect_display_width" ];

  meta = {
    description = "Syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "difft";
  };
})
