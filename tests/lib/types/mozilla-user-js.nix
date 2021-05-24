{ config, lib, pkgs, ... }:
with lib;
with config.lib.mozilla.prefs;
{
  options.tested.moz = mkOption { type = types.anything; };
  config = {
    tested.moz = {
      "fromNormalized".text = user-js.fromNormalized {
        "a.num" = 1;
        "a.text" = "asdf";
        "b.bool" = true;
      };
      "fromAttrs".text = user-js.fromAttrs {
        a = {
          num = 1;
          text = "asdf";
          bool = true;
        };
      };
    };

    home.file = config.tested.moz;
    nmt.script = ''
      for f in ${concatStringsSep " " (attrNames config.tested.moz)}
      do
        sort -d -o $f $out/tested/home-files/$f
        assertFileContent $f ${
          pkgs.writeText "user.js" ''
            user_pref('b.bool', true);
            user_pref('a.num', 1);
            user_pref('a.text', "asdf");
          ''
        }
      done
    '';
  };
}