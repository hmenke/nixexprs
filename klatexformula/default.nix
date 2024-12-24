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
  version = "KLF_4-1-0";

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
