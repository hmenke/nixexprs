{
  autoreconfHook,
  fetchurl,
  gdb,
  lib,
  makeWrapper,
  perl,
  python3,
  stdenv,
}:

stdenv.mkDerivation (final: {
  pname = "verrou";
  version = "2.7.0";

  src = fetchurl {
    url = "https://github.com/edf-hpc/verrou/releases/download/v${final.version}/valgrind-3.26.0_verrou-${final.version}.tar.gz";
    hash = "sha256-5enYsk0yRRVBfCwTSudtXdVmg1IZ1krw+mb2UsHWavc=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  hardeningDisable = [
    "stackprotector"
  ];
  NIX_ENFORCE_NO_NATIVE = false;

  # GDB is needed to provide a sane default for `--db-command'.
  # Perl is needed for `callgrind_{annotate,control}'.
  buildInputs = [
    gdb
    perl
    python3
  ];
  nativeBuildInputs = [
    autoreconfHook
    perl
    makeWrapper
  ];

  enableParallelBuilding = true;
  separateDebugInfo = true;

  postPatch = ''
    substituteInPlace verrou/Makefile.am --replace-fail '/usr/share' '/share'
    patchShebangs verrou/generateBackendInterOperator.py
    patchShebangs verrou/generateInstrumentOp_impl.py
    patchShebangs verrou/generateOpImpl.py
  '';

  configureFlags = [
    "--enable-only64bit"
    "--enable-verrou-fma"
    "--enable-verrou-quadmath"
  ];

  postInstall = ''
    for i in $out/libexec/valgrind/*.supp; do
      substituteInPlace $i \
        --replace 'obj:/lib' 'obj:*/lib' \
        --replace 'obj:/usr/X11R6/lib' 'obj:*/lib' \
        --replace 'obj:/usr/lib' 'obj:*/lib'
    done

    rm $out/env.sh
    for f in $(find $out/bin -type f -executable); do
      wrapProgram "$f" \
        --set-default VERROU_COMPILED_WITH_FMA yes \
        --set-default VERROU_COMPILED_WITH_QUAD yes
    done
  '';

  meta = {
    homepage = "https://github.com/edf-hpc/verrou";
    description = "Floating-point errors checker";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = [ "x86_64-linux" ];
  };
})
