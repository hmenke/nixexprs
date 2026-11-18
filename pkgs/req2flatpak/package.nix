{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "req2flatpak";
  version = "0.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "johannesjh";
    repo = "req2flatpak";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VvrjknnihL11BgqnwK9IE42iEChJWXfe2L0ayTc99nU=";
  };

  nativeBuildInputs = [ python3.pkgs.poetry-core ];
  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    packaging
    pyyaml
  ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  disabledTests = [
    "test_api"
    "test_cli_with_reqs_as_args"
    "test_cli_with_reqs_as_args_yaml"
    "test_cli_with_reqs_as_file"
    "test_cli_with_reqs_as_file_yaml"
  ];

  meta = {
    description = "Convert Python package requirements to Flatpak build manifests";
    homepage = "https://johannesjh.github.io/req2flatpak/";
    changelog = "https://github.com/johannesjh/req2flatpak/blob/v${finalAttrs.version}/docs/source/changelog.rst";
    license = lib.licenses.mit;
    mainProgram = "req2flatpak";
    maintainers = with lib.maintainers; [ hmenke ];
  };
})
