{ config, lib, ... }:
{
  # Create "~/downloads" directory.
  home.file."Downloads/.keep".text = "";

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles = lib.mkMerge [
      {
        main = {
          id = 0;
          isDefault = true;
          settings = {
            # Never ask to remember passwords
            "signon.rememberSignons" = false;
            # Set download directory
            "browser.download.dir" = "/home/${config.home.username}/Downloads";
            # 3 = restore previous session (0 = blank, 1 = home, 2 = last visited)
            "browser.startup.page" = 3;
          };
        };
      }
      (lib.mkIf (config.desktopEnvironment.profile == "work") {
        lanosrep = {
          id = 1;
          settings = {
            "signon.rememberSignons" = false;
            "browser.download.dir" = "/home/${config.home.username}/Downloads";
            # 3 = restore previous session (0 = blank, 1 = home, 2 = last visited)
            "browser.startup.page" = 3;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
          userChrome = ''
            :root {
              --toolbar-bgcolor: #2d1b4e !important;
              --toolbar-color: #e8d5ff !important;
              --tab-selected-bgcolor: #5b2d8e !important;
              --tab-selected-color: #ffffff !important;
              --toolbarbutton-icon-fill: #e8d5ff !important;
            }
          '';
        };
      })
    ];

    /* ---- POLICIES ---- */
    # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # ProtonPass:
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
            installation_mode = "force_installed";
          };
          # Vimium-FF:
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
          };
        };
     };
  };
}
