{ lib, pkgs, ... }:
{
  home.activation.generateSshKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SSH_DIR="$HOME/.ssh"
    KEY_FILE="$SSH_DIR/id_ed25519"
    if [[ ! -f "$KEY_FILE" ]]; then
      $DRY_RUN_CMD mkdir -p "$SSH_DIR"
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f $KEY_FILE -N "" -q
    fi;
  '';
}
