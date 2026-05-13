{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.69.0-unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "7ccfcb315f7e46fd015809416c7d7dffa5be7078";
    hash = "sha256-BxJ36OGsec3TPO2QyljtN11HU/aWVBaXaQySAtmG8Q8=";
  };

  cargoHash = "sha256-SXgAmRK5SaMNrJpr52bBqRdTCtkfje1IKk6wJpyEI1w=";

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
