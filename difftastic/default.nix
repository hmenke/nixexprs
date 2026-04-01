{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.68.0-unstable-2026-03-23";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "aeaf5638ba7515e04dc9067c7c1b35fc9d7350c3";
    hash = "sha256-v1whXBpdEDBCPgykjGLQpx+g/RjLwNnQgahO1qHc07U=";
  };

  cargoHash = "sha256-zp/gS02uTmix75G73o2l6UtFmkMaRPUbXmbzjGPahMg=";

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
