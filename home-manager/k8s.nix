{ pkgs, ... }: {
  home.packages = with pkgs; [
    kind
    kubectl
    tilt
    k9s
  ];
}
