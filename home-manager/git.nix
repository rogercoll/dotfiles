{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      "**/*.neck*"
      "**/target"
      "**/.cursor"
    ];

    settings = {
      user = {
        name = "Roger Coll";
        email = "rogercoll@protonmail.com";
      };

      alias = {
        st = "status";
        co = "checkout";
        ci = "commit";
        df = "diff";
        br = "branch";
        brs = "!git for-each-ref --sort='authordate:iso8601' --format='%(authordate:relative)%09%(refname:short)' refs/heads | fzf --tac --bind 'enter:execute(echo {} | rev | cut -f1 | rev | xargs git checkout)+abort,tab:execute-silent(echo {} | rev | cut -f1 | rev | xclip -selection clipboard)+abort'";
        glo = "log --graph --oneline --decorate --all";
        gloo = "log --graph --abbrev-commit --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
        l = "log --name-status";
        purge-branches = "!sh -c 'git branch --merged | grep -v \"^*\" | xargs git branch -d'";
        um-files = "diff --name-only --diff-filter=U";
      };

      core = {
        editor = "nvim";
        hooksPath = "~/.global_githooks";
      };
      tag.sort = "version:refname";
      init.defaultBranch = "main";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      color = {
        branch = "auto";
        diff = "auto";
        status = "auto";
        showbranch = "auto";
        ui = true;
      };
      gpg.format = "ssh";
    };
  };
}
