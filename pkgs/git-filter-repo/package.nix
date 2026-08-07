{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-filter-repo";
  version = "2.47.0";

  src = fetchFromGitHub {
    owner = "newren";
    repo = "git-filter-repo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hb5IolmqJUv25MPg4kLrtfLAehFfEXya5D2frl6g/JU=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    install -v -Dm0755 git-filter-repo $out/bin/git-filter-repo
  '';

  meta = {
    description = "Quickly rewrite git repository history";
    homepage = "https://github.com/newren/git-filter-repo";
    changelog = "https://github.com/newren/git-filter-repo/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit gpl2Plus ];
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "git-filter-repo";
  };
})
