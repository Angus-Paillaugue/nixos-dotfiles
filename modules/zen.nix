{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options = {
    zen.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zen Browser";
    };
  };

  config = lib.mkIf config.zen.enable {
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      env = {
        GTK_THEME = "adw-gtk3-dark";
      };

      profiles.default = {
        settings = {
          "zen.workspaces.continue-where-left-off" = true;
        };
        mods = [
          "81fcd6b3-f014-4796-988f-6c3cb3874db8" # Zen Context Menu
          "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
          "f4866f39-cfd6-4498-ab92-54213b8279dc" # Animations Plus
          "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
          "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
          "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
          "664c54f9-d97d-410b-a479-23dd8a08a628" # Better Tab Indicators
          "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
          "8039de3b-72e1-41ea-83b3-5077cf0f98d1" # Trackpad Animation
        ];
        search = {
          force = true; # Enforce declared search engines on each rebuild
          default = "4get";
          engines = {
            "4get" = {
              name = "Fourget";
              urls = [
                {
                  template = "https://search.home.paillaugue.fr/web?s={searchTerms}";
                }
              ];
            };
          };
        };
        containersForce = true; # Delete containers
        containers = { };
      };

      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    };
  };
}
