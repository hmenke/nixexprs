{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "prometheus-slurm-exporter";
  version = "0.24";

  src = fetchFromGitHub {
    owner = "vpenso";
    repo = "prometheus-slurm-exporter";
    rev = finalAttrs.version;
    hash = "sha256-WWAioKaK8qxKgQTxn89rslW8OMvNRuOV6GSWu2XA7w4=";
  };

  vendorHash = "sha256-TCMYaCRR62dBbJD/lZ6vVd0jM0gfJjkjJJaI8lCiND0=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];
  doCheck = false;

  meta = {
    description = "Prometheus exporter for performance metrics from Slurm";
    homepage = "https://github.com/vpenso/prometheus-slurm-exporter";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "prometheus-slurm-exporter";
  };
})
