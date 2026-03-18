{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.68.0-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    rev = "2aacc5eae02ea0143b5ef4114c9084864f528e48";
    hash = "sha256-PUZwvtayNuvBXbVMPVMZhd5FJm63RlTpvpBNCLqpI+c=";
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
