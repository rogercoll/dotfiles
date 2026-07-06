{
  description = "Neck's infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      thinkpad = {
        username = "neck";
        hostname = "thinkpad";
        ip = "192.168.8.135";
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          lua-language-server
          nixd
          nixfmt
          stylua
        ];
      };

      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
          ./hardware-configuration/thinkpad.nix
          ./nixos/bluetooth.nix
          ./nixos/device.nix
          ./nixos/locale.nix
          ./nixos/network.nix
          ./nixos/pam.nix
          ./nixos/pipewire.nix
          ./nixos/startup.nix
          ./nixos/desktop
          ./nixos/tlp.nix
          ./nixos/virtualisation.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${thinkpad.username} = {
                imports = [
                  ./home-manager
                  ./home-manager/claude.nix
                  ./home-manager/direnv.nix
                  ./home-manager/fzf.nix
                  ./home-manager/git.nix
                  ./home-manager/keygen.nix
                  ./home-manager/latex.nix
                  ./home-manager/neovim.nix
                  ./home-manager/ollama.nix
                  ./home-manager/ssh.nix
                  ./home-manager/theme.nix
                  ./home-manager/tmux.nix
                  ./home-manager/zsh.nix
                  ./home-manager/desktop
                  ./home-manager/desktop/brave.nix
                ];

                theme.name = "gruvbox";

                knownHosts = [ thinkpad ];

                desktopEnvironment = {
                  wallpaper = ./assets/wallpapers/ancient-greece.jpeg;
                  profile = "work";
                };
              };
            };

            desktopEnvironment = {
              displayManager = "none";
              sessions = [ "niri" ];
            };

            profile = {
              username = thinkpad.username;
              hostname = thinkpad.hostname;
              shell = "zsh";
            };
          }
        ];
      };
    };
}
