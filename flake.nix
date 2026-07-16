{
  description = "Neck's infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

};

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-alien,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };


      wxct = {
        username = "neck";
        hostname = "wxct";
        ip = "192.168.8.135";
      };

      pxct = {
        username = "neck";
        hostname = "pxct";
        ip = "192.168.8.136";
      };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            lua-language-server
            nixd
            nixfmt
            stylua
          ];
        };

        kibana =
          let
            nodejs = pkgs.stdenv.mkDerivation {
              pname = "nodejs";
              version = "24.18.0";
              src = pkgs.fetchurl {
                url = "https://nodejs.org/dist/v24.18.0/node-v24.18.0-linux-x64.tar.gz";
                hash = "sha256-eDEwmElj23upy9AQierywu+wVcfBaTyUMXS5Z7MFDLg=";
              };
              nativeBuildInputs = [ pkgs.autoPatchelfHook ];
              buildInputs = with pkgs; [ stdenv.cc.cc.lib ];
              installPhase = ''
                mkdir -p $out
                cp -r . $out
              '';
            };
          in
          pkgs.mkShell {
            packages = [ nodejs (pkgs.yarn.override { inherit nodejs; }) ];
            shellHook = ''
              export NPM_CONFIG_PREFIX="$HOME/.npm-global"
              export PATH="$HOME/.npm-global/bin:$PATH"
            '';
          };

      elasticsearch =
        let
          temurin21 = pkgs.javaPackages.compiler.temurin-bin.jdk-21;
        in
        pkgs.mkShell {
          packages = [ temurin21 ];
          JAVA_HOME = "${temurin21}";
        };

        opentelemetry-ebpf-profiler =
          let
            llvmPkgs = pkgs.llvmPackages;
          in
          pkgs.mkShell {
            packages = [
              pkgs.go_1_25
              llvmPkgs.clang            # wrapped — used for CGO / regular C
              llvmPkgs.clang-unwrapped  # raw binary — used for eBPF compilation
              llvmPkgs.llvm
              llvmPkgs.clang-tools
              pkgs.gcc
              pkgs.binutils
              pkgs.musl
              pkgs.gnumake
              pkgs.git
              pkgs.pkg-config
            ];

            shellHook = ''
              # Point eBPF Makefile vars at the unwrapped clang so Nix wrapper flags
              # (e.g. -nostdlibinc) are not injected — they cause -Werror failures.
              export BPF_CLANG=${llvmPkgs.clang-unwrapped}/bin/clang
              export BPF_LINK=${llvmPkgs.llvm}/bin/llvm-link
              export LLC=${llvmPkgs.llvm}/bin/llc
              export STRIP=${llvmPkgs.llvm}/bin/llvm-strip
              export CLANG_FORMAT=${llvmPkgs.clang-tools}/bin/clang-format

              # Makefile sets CC=x86_64-linux-gnu-gcc; Nix exposes it as plain gcc.
              _WRAP="$HOME/.cache/ebpf-profiler-cc-wrappers"
              mkdir -p "$_WRAP"
              for _bin in gcc g++ objcopy; do
                _src="$(command -v $_bin 2>/dev/null)"
                [ -n "$_src" ] && ln -sf "$_src" "$_WRAP/x86_64-linux-gnu-$_bin"
              done
              export PATH="$_WRAP:$PATH"
              export CGO_ENABLED=0
              export CC="x86_64-linux-gnu-gcc"
              export OBJCOPY="x86_64-linux-gnu-objcopy"
            '';
          };
      };

      nixosConfigurations.pxct = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
          ./hardware-configuration/pxct.nix
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
            system.nixos.tags = [ "pxct" ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${pxct.username} = {
                imports = [
                  ./home-manager
                  ./home-manager/claude.nix
                  ./home-manager/direnv.nix
                  ./home-manager/fzf.nix
                  ./home-manager/git.nix
                  ./home-manager/keygen.nix
                  ./home-manager/latex.nix
                  ./home-manager/development.nix
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

                knownHosts = [ pxct ];

                desktopEnvironment = {
                  wallpaper = ./assets/wallpapers/gruvbox-cyberpunk-girl.png;
                  profile = "personal";
                  wayBarScreen = "eDP-1";
                };
              };
            };

            desktopEnvironment = {
              displayManager = "none";
              sessions = [ "niri" ];
            };

            profile = {
              username = pxct.username;
              hostname = pxct.hostname;
              shell = "zsh";
            };

            programs.nix-ld.enable = true;

            system.activationScripts.binbash.text = ''
              ln -sfn ${pkgs.bash}/bin/bash /bin/bash
            '';
          }
        ];
      };

      nixosConfigurations.wxct = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          nix-alien-pkg = nix-alien.packages.${system}.nix-alien;
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./hardware-configuration/wxct.nix
          ./nixos/bluetooth.nix
          ./nixos/device.nix
          ./nixos/elastic-agent.nix
          ./nixos/locale.nix
          ./nixos/network.nix
          ./nixos/pam.nix
          ./nixos/pipewire.nix
          ./nixos/startup.nix
          ./nixos/desktop
          ./nixos/tlp.nix
          ./nixos/virtualisation.nix
          {
            system.nixos.tags = [ "wxct" ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${wxct.username} = {
                imports = [
                  ./home-manager
                  ./home-manager/claude.nix
                  ./home-manager/direnv.nix
                  ./home-manager/fzf.nix
                  ./home-manager/git.nix
                  ./home-manager/keygen.nix
                  ./home-manager/latex.nix
                  ./home-manager/development.nix
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

                knownHosts = [ wxct ];

                desktopEnvironment = {
                  wallpaper = ./assets/wallpapers/vintage-misty-forest.jpg;
                  profile = "work";
                  wayBarScreen = "eDP-1";
                };
              };
            };

            desktopEnvironment = {
              displayManager = "none";
              sessions = [ "niri" ];
            };

            profile = {
              username = wxct.username;
              hostname = wxct.hostname;
              shell = "zsh";
            };

            # Dynamic linker shim for unpatched Linux binaries (e.g. JDKs downloaded by Gradle).
            programs.nix-ld.enable = true;

            # Some tools (e.g. Bazel) hardcode /bin/bash which does not exist on NixOS.
            system.activationScripts.binbash.text = ''
              ln -sfn ${pkgs.bash}/bin/bash /bin/bash
            '';
          }
        ];
      };
    };
}
