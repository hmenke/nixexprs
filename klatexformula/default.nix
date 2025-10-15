{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, qttools
, qtx11extras
, ghostscript
}:

mkDerivation rec {
  pname = "klatexformula";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "klatexformula";
    repo = "klatexformula";
    rev = "KLF_4-1-0";
    hash = "sha256-0w9JlJoJz3EBkdxIGXPK1UsirGjX+fsc0Mf+hc5ZT4k=";
  };

  patches = [
    (fetchpatch {
      name = "applied-suggested-patch-fixes-53.patch";
      url = "https://github.com/klatexformula/klatexformula/commit/1ba3a77a6095fff45b73413ef9b4319c56921d48.patch";
      hash = "sha256-iposz1ee/8RQ43V7bHdYwKWLL5h5MCVK/XIiWzyUzIo=";
    })
    (fetchpatch {
      name = "Compatibility-with-CMake-4.patch";
      url = "https://github.com/klatexformula/klatexformula/pull/80/commits/ff8e7fd3b8e21eaac77bfc8e6ff90b48ecc3bc1c.patch";
      hash = "sha256-dW0j48/+BP+NyNuP24XpvHQvJH8uGaeGE0TtqCKAIx8=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qttools
    qtx11extras
  ];

  meta = with lib; {
    description = "KLatexFormula is an easy-to-use graphical application for generating images from LaTeX equations.";
    homepage = "https://klatexformula.sourceforge.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hmenke ];
  };
}
