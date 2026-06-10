{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "shellcheck-bin";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/koalaman/shellcheck/releases/download/v${finalAttrs.version}/shellcheck-v${finalAttrs.version}.linux.x86_64.tar.xz";
    hash = "sha256-jDvhKwXVwXegTCnjx4zomshvFZVoHKsUm2W5fE4icZg=";
  };

  sourceRoot = ".";

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = "install -v -Dt $out/bin shellcheck-v${finalAttrs.version}/shellcheck";
})
