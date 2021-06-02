{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.terminator;

  toValue = val:
    if val == null then
      "None"
    else if val == true then
      "True"
    else if val == false then
      "False"
    else
      ''"${toString val}"'';

  toConfigObject = let
    toKey = depth: key:
      if depth == 0 then key else toKey (depth - 1) "[${key}]";
    go = depth: obj:
      flatten (mapAttrsToList (key: val:
        if isAttrs val then
          [ (toKey depth key) ] ++ go (depth + 1) val
        else
          [ "${key} = ${toValue val}" ]) obj);
  in obj: concatStringsSep "\n" (go 1 obj);

in {
  meta.maintainers = [ maintainers.chisui ];

  options.programs.terminator = {
    enable = mkEnableOption "terminator tiling terminal emulator";

    package = mkOption {
      type = types.package;
      default = pkgs.terminator;
      defaultText = literalExample "pkgs.terminator";
      description = "terminator package to install.";
    };

    config = mkOption {
      default = null;
      description = "configuration for terminator";
      type = types.nullOr (types.submodule {
        options = let
          mkConfigOpt = name:
            (mkOption {
              default = { };
              type = types.attrsOf types.anything;
              description =
                "configration for ${name}. for options refere to the terminator_config manpage.";
            });
        in {
          global_config = mkConfigOpt "global_config";
          keybindings = mkConfigOpt "keybindings";
          profiles = mkConfigOpt "profiles";
          plugins = mkConfigOpt "plugins";
        };
      });
    };

    extraConfig = mkOption {
      default = { };
      type = types.attrsOf types.anything;
      description = "Additional configuration to add.";
      example = { "shading" = 15; };
    };
  };

  config = mkIf cfg.enable { home.packages = [ cfg.package ]; }
    // mkIf (cfg.config != null) {
      xdg.configFile."terminator/config".text = toConfigObject cfg.config;
    };
}
