{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    gopls
    rustup
    gnumake
    gcc
  ];
}
