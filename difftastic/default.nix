{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.68.0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "bde7d5cb647bc29671b1205a026786ca9575b9fd";
    hash = "sha256-XgM48HrBpCfbhKkQztcW9kK32NAO08qsmEaiFHHnq2U=";
  };

  cargoHash = "sha256-Sw1wDSmQLUMGwaFnbGCG0jBzMUIS4Lx14vIIEEGs++g=";

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
