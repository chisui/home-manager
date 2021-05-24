{ config, lib, pkgs, ... }:
with lib;
with config.lib.mozilla.prefs;
{
  options.tested.moz = mkOption { type = types.anything; };
  config = {
    tested.moz = {
      "fromNormalized".text = user-js.fromNormalized {
        "b.bool" = true;
        "a.num" = 1;
        "a.text" = "asdf";
      };
      "fromAttrs".text = user-js.fromAttrs {
        b.bool = true;
        a = {
          num = 1;
          text = "asdf";
        };
      };
    };

    home.file = config.tested.moz;
    nmt.script = let
      expectedFile = pkgs.writeText "user.js" ''
        user_pref('a.num', 1);
        user_pref('a.text', "asdf");
        user_pref('b.bool', true);
      '';
    in ''
      ${pkgs.hexdump}/bin/hexdump ${expectedFile} > expected.hex
      for f in ${concatStringsSep " " (attrNames config.tested.moz)}
      do
        sort -d -o $f $out/tested/home-files/$f
        ${pkgs.hexdump}/bin/hexdump $f > $f.hex
        diff -y $f.hex expected.hex
        assertFileContent $f.hex expected.hex
      done
    '';
  };
}