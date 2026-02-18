{
  dbus,
  fetchFromGitHub,
  git,
  lib,
  libgit2,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitbutler-cli";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-kkvghzNNsSv1mI+99y/LGPB715itgacE9uy7Cq3xU/M=";
  };

  cargoPatches = [ ./remove-duplicate-packages.patch ];
  cargoHash = "sha256-Ee+KGo8fJRh9IFkvz9Nrgod8/Anz9M1RQpTwlosfmWE=";

  env = {
    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    dbus
    libgit2
    openssl
  ];
  cargoBuildFlags = [ "--package but" ];

  doCheck = false; # TODO
  nativeCheckInputs = [ git ];
  cargoTestFlags = [ "--package but" ];

  postInstall = ''
    export HOME="$TMPDIR"
    mkdir -p $out/share/bash-completion/completions/
    $out/bin/but completions bash > $out/share/bash-completion/completions/but.bash
    mkdir -p $out/share/zsh/site-functions/
    $out/bin/but completions zsh > $out/share/zsh/site-functions/_but
  '';

  meta = {
    description = "The GitButler version control client";
    homepage = "https://gitbutler.com";
    license = with lib.licenses; [ fsl11Mit ];
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "but";
  };
})
