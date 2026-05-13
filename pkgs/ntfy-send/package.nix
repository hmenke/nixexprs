{
  lib,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  ## error: output '/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-ntfy-send-0.0' is not allowed to refer to the following paths:
  ##          /nix/store/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb-go-1.25.9
  #__structuredAttrs = true;
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
