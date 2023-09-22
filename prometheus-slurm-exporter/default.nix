{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "prometheus-slurm-exporter";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "vpenso";
    repo = "prometheus-slurm-exporter";
    rev = version;
    sha256 = "sha256-KS9LoDuLQFq3KoKpHd8vg1jw20YCNRJNJrnBnu5vxvs=";
  };

  vendorSha256 = "sha256-A1dd9T9SIEHDCiVT2UwV6T02BSLh9ej6LC/2l54hgwI=";

  CGO_ENABLED = 0;
  ldflags = [ "-s" "-w" "-extldflags '-static'" ];
  doCheck = false;

  meta = with lib; {
    description = "Prometheus exporter for performance metrics from Slurm";
    homepage = "https://github.com/vpenso/prometheus-slurm-exporter";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.hmenke ];
    mainProgram = "prometheus-slurm-exporter";
  };
}
