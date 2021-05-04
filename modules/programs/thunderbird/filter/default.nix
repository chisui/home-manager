{ lib, ... }:

with lib; 
with (import ./lib.nix { inherit lib; });

{ config, name, ... }: {
  options = {
    name = mkOption {
      type = types.str;
      default = name;
      description = "Name of the filter.";
    };
    enabled = mkOption {
      type = types.bool;
      default = true;
      description = "whether to enable this filter.";
    };
    when = mkOption {
      type = types.functionTo (types.listOf types.int);
      default = flags:
        with flags; [
          manually
          before-junk
        ];
      example = literalExample
        "flags: with flags; [ manually before-junk ]";
      description = ''
        When the filter should be applied.
        This is stored as an int with certain bitflags. An attribute set with the corresponding bitflags is passed to the function.
        The function has to return a list of all these flags.
        </para><para>
        Flags:
        ${concatStrings (mapAttrsToList (name: value: ''
          ${name} = ${toString value}
        '') filterFlags)}
      '';
    };
    condition = mkOption {
      type = types.str;
      description =
        "filter conditions that all have to match for this filter to be applied. Either this option or `any` has to be present.";
    };
    actions = mkOption {
      description = "filter actions";
      type = types.listOf types.unspecified;
    };
  };
}