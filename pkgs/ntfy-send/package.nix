{
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "ntfy-send";
  version = "0.0";

  src = ./src;

  vendorHash = "sha256-Pg3SEt7nztXNJINeFjWAvjn2F/iJ3AKB16jTfh3lmRc=";

  meta = {
    description = "Send and receive notifications via ntfy.sh";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    mainProgram = "ntfy-send";
  };
})
