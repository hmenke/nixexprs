{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.69.0-unstable-2026-05-05";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "a81564d256efe63d667139716113b35a51cd8717";
    hash = "sha256-kJ33bKusvmAr93zafhxlqLEnym8x1gc1owlX0PxiMs4=";
  };

  cargoHash = "sha256-esTsIpw4n81RIE6xanrtI7g25RCDz5nwJOpuOOrgSfE=";

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
