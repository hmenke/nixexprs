{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "req2flatpak";
  version = "0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "johannesjh";
    repo = "req2flatpak";
    rev = "v${version}";
    sha256 = "sha256-Q4lqlLJ59DiXy6fClU2dcwR/5eWM9s0QpYTDWP1UQEI=";
  };

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
