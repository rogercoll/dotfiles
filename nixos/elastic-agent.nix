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
# Useful commands:
#   sudo nix-alien /opt/Elastic/Agent/elastic-agent -- status --output json
#   sudo nix-alien /opt/Elastic/Agent/elastic-agent -- diagnostics

{ lib, nix-alien-pkg, ... }:

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
}
