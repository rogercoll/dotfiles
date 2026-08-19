# Elastic Agent — NixOS service via nix-alien
#
# nix-alien wraps the pre-built binary so it finds its dynamic libraries and
# runtime tools (e.g. getent) in the Nix store instead of standard FHS paths.
#
# First-time setup (run once, then start the service):
#
#   1. Extract the agent:
#      sudo mkdir -p /opt/Elastic/Agent
#      sudo tar -xzf elastic-agent-*-linux-x86_64.tar.gz -C /opt/Elastic/Agent --strip-components=1
#
#   2. Enroll (Ctrl+C once you see "Restarting agent daemon"):
#      sudo nix-alien /opt/Elastic/Agent/elastic-agent -- enroll \
#        --url=https://*** --enrollment-token=*** --force
#
#   3. Start the service:
#      sudo systemctl start elastic-agent
#
# Updates are handled automatically by the elastic-agent-updater timer (daily).
# To trigger a manual update: sudo systemctl start elastic-agent-updater
#
# Useful commands:
#   sudo nix-alien /opt/Elastic/Agent/elastic-agent -- status --output json
#   sudo nix-alien /opt/Elastic/Agent/elastic-agent -- diagnostics

{ lib, pkgs, nix-alien-pkg, ... }:

{
  environment.systemPackages = [ nix-alien-pkg ];

  systemd.services.elastic-agent = {
    description = "Elastic Agent is a unified agent to observe, monitor and protect your system.";

    unitConfig = {
      StartLimitBurst = 10;
      StartLimitIntervalSec = 5;
    };

    serviceConfig = {
      ExecStart = "${nix-alien-pkg}/bin/nix-alien /opt/Elastic/Agent/elastic-agent";
      WorkingDirectory = "/opt/Elastic/Agent";
      Restart = "always";
      KillMode = "process";
      RestartSec = 120;
      Environment = "PATH=/run/wrappers/bin:/nix/profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    };

    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.elastic-agent-updater = {
    description = "Update Elastic Agent binary to the latest release";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = pkgs.writeShellScript "elastic-agent-update" ''
        set -euo pipefail

        INSTALL_DIR="/opt/Elastic/Agent"
        VERSION_FILE="$INSTALL_DIR/.nix-managed-version"

        LATEST=$(${pkgs.curl}/bin/curl -sf "https://artifacts-api.elastic.co/v1/versions" | \
          ${pkgs.jq}/bin/jq -r '[.versions[] | select(test("^[0-9]+\\.[0-9]+\\.[0-9]+$"))] | sort | last')

        CURRENT=$(cat "$VERSION_FILE" 2>/dev/null || echo "0.0.0")

        if [ "$LATEST" = "$CURRENT" ]; then
          echo "elastic-agent is already up-to-date ($CURRENT)"
          exit 0
        fi

        echo "Updating elastic-agent: $CURRENT -> $LATEST"
        TMP=$(mktemp -d)
        trap "rm -rf $TMP" EXIT

        DOWNLOAD_URL=$(${pkgs.curl}/bin/curl -sf \
          "https://artifacts-api.elastic.co/v1/search/$LATEST/elastic-agent" | \
          ${pkgs.jq}/bin/jq -r \
            '.packages | to_entries[]
             | select(.key | test("elastic-agent-[0-9.]+-linux-x86_64\\.tar\\.gz$"))
             | .value.url' | head -1)

        ${pkgs.curl}/bin/curl -fsSL "$DOWNLOAD_URL" -o "$TMP/agent.tar.gz"
        ${pkgs.gnutar}/bin/tar --use-compress-program=${pkgs.gzip}/bin/gzip -xf "$TMP/agent.tar.gz" -C "$TMP" --strip-components=1

        systemctl stop elastic-agent
        rm -rf "''${INSTALL_DIR:?}"/*
        cp -a "$TMP/." "$INSTALL_DIR/"
        echo "$LATEST" > "$VERSION_FILE"

        # Force nix-alien to re-resolve dynamic libraries for the new binary
        rm -rf /root/.cache/nix-alien

        systemctl start elastic-agent
        echo "elastic-agent updated to $LATEST"
      '';
    };
  };

  systemd.timers.elastic-agent-updater = {
    description = "Daily check for Elastic Agent updates";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
