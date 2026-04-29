{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.68.0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "c7a5a6810360ab092c21fa56b4a4f17f255a6756";
    hash = "sha256-0ejjTdBncX0yvkvOu95JwthwRir2JYaK2Y3Fe8dGjsc=";
  };

  cargoHash = "sha256-by/gl6qI6mc93Kxn0BdIhkL/gtoHcGwdzrGiT5KTmP4=";

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
