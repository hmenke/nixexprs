{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "req2flatpak";
  version = "0.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "johannesjh";
    repo = "req2flatpak";
    rev = "v${version}";
    hash = "sha256-gj0SP4SQpkaT1dCov1l4qVWhy5J3Q+s9q3Q7TN83H/Q=";
  };

  postPatch = ''
    substituteInPlace ./pyproject.toml \
      --replace-fail 'packaging = { version = "^21.3" }' 'packaging = { version = ">=21.3" }'
  '';

  nativeBuildInputs = with python3.pkgs; [ poetry-core ];
  propagatedBuildInputs = with python3.pkgs; [ setuptools pyyaml ];

  meta = {
    description = "Convert Python package requirements to Flatpak build manifests";
    homepage = "https://johannesjh.github.io/req2flatpak/";
    license = lib.licenses.mit;
    mainProgram = "req2flatpak";
    maintainers = with lib.maintainers; [ hmenke ];
  };
}
