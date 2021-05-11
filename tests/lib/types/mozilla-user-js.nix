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

    home.file = {
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
    nmt.script = ''
      sort -d -o expected.user.js ${./expected.user.js}
      for f in ${concatStringsSep " " (attrNames config.tested.moz)}
      do
        sort -d -o $f $out/tested/home-files/$f
        assertFileContent $f expected.user.js
      done
    '';
  };
}