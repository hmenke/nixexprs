{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dhcpdoctor";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ArnesSI";
    repo = "dhcpdoctor";
    rev = version;
    sha256 = "sha256-u0VmIWvuOGmYliB5eomU1yUc+TEgkPDV8IW94swR8d4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'poetry>=0.12' 'poetry-core' \
      --replace 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = with python3.pkgs; [ poetry-core ];
  propagatedBuildInputs = with python3.pkgs; [ scapy ];

  meta = {
    description = "Tool for testing IPv4 and IPv6 DHCP services";
    homepage = "https://github.com/ArnesSI/dhcpdoctor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmenke ];
  };
}
