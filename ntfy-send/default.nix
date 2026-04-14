{
  lib,
  buildGoModule,
}:

buildGoModule rec {
  pname = "ntfy-send";
  version = "0.0";

  src = ./src;

  vendorHash = "sha256-Pg3SEt7nztXNJINeFjWAvjn2F/iJ3AKB16jTfh3lmRc=";

  meta = with lib; {
    description = "Send and receive notifications via ntfy.sh";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.hmenke ];
    mainProgram = "ntfy-send";
  };
}
