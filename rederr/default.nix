{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation (final: {
  pname = "rederr";
  version = "0-unstable-2018-11-22";

  src = fetchFromGitHub {
    owner = "poettering";
    repo = "rederr";
    rev = "4ef6ede025ddf25d61b6231687810b95d3b5ffa0";
    hash = "sha256-CaXdhKaduWBRVcW7jnJJf26Tgiq134PgtXqSWtRbjKs=";
  };

  patches = [
    ./missing-include.patch
  ];

  nativeBuildInputs = [ meson ninja ];

  meta = {
    description = "Colour your stderr red";
    homepage = "https://github.com/poettering/rederr";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "rederr";
    maintainers = with lib.maintainers; [ hmenke ];
  };
})
