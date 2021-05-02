{ lib, ... }:

with lib;

{ config, name, ... }: {
  options = {
    name = mkOption {
      type = types.str;
      default = name;
      description = "Profile name.";
    };

    id = mkOption {
      type = types.ints.unsigned;
      default = 0;
      description = ''
        Profile ID. This should be set to a unique number per profile.
      '';
    };

    settings = mkOption {
      type = with types; attrsOf (either bool (either int str));
      default = { };
      example = literalExample ''
        {
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "general.useragent.locale" = "en-GB";
        }
      '';
      description = "Attribute set of Thunderbird preferences.";
    };

    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExample ''
        with pkgs.nur.repos.chisui.thunderbird-addons; [
          TODO
        ]
      '';
      description = ''
        List of Thunderbird add-on packages to install for this profile. Some
        pre-packaged add-ons are accessible from NUR,
        <link xlink:href="https://github.com/nix-community/NUR"/>.
        Once you have NUR installed run

        <screen language="console">
          <prompt>$</prompt> <userinput>nix-env -f '&lt;nixpkgs&gt;' -qaP -A nur.repos.chisui.thunderbird-addons</userinput>
        </screen>

        to list the available Thunderbird add-ons.

        </para><para>

        Note that it is necessary to manually enable these
        extensions inside Thunderbird after the first installation.

        </para><para>

        Extensions listed here will only be available in Firefox
        profiles managed through the
        <link linkend="opt-programs.thunderbird.profiles">programs.thunderbird.profiles</link>
        option. This is due to recent changes in the way Thunderbird
        handles extension side-loading.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra preferences to add to <filename>user.js</filename>.
      '';
    };

    userChrome = mkOption {
      type = types.lines;
      default = "";
      description = "Custom Thunderbird user chrome CSS.";
    };

    userContent = mkOption {
      type = types.lines;
      default = "";
      description = "Custom Thunderbird user content CSS.";
    };

    path = mkOption {
      type = types.str;
      default = name;
      description = "Profile path.";
    };

    isDefault = mkOption {
      type = types.bool;
      default = config.id == 0;
      defaultText = "true if profile ID is 0";
      description = "Whether this is a default profile.";
    };
  };
}