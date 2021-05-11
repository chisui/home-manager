{ lib }:
with lib;
with builtins;
{ 
  profiles-ini = profiles: 
    let
      nameToProfile = id: name:
        nameValuePair name {
          inherit name id;
          isDefault = id == 0;
        };

      normalize = ps: if isList ps then listToAttrs (imap nameToProfile ps)
                 else if isString ps then normalize [ ps ]
                 else ps;

      mkProfile = k: { id, name ? k, path ? name, isDefault ? false }:
        nameValuePair "Profile${toString id}" {
          Name = name;
          Path = path;
          IsRelative = 1;
          Default = if isDefault then 1 else 0;
        };

    in generators.toINI { } (mapAttrs' mkProfile (normalize ps) // {
        General = { StartWithLastProfile = 1; };
      });

  prefs = let
      normalize' = path: val:
          if isAttrs val then flatten (mapAttrsToList (k: v: normalize' (path ++ [k]) v) val)
          else [{ name = path; value = val; }];
      unPath = { name, value }: { inherit value; name = concatStringsSep "." name; };
      normalize = ps: listToAttrs (map unPath (normalize' [] ps));
      mkEntry = f: k: v: "${f}('${k}', ${toJSON v});";
      unlines = concatStringsSep "\n";
    in {
      inherit normalize mkEntry;
      user-js = rec {

        fromNormalized = ps: unlines (mapAttrsToList (mkEntry "user_pref") ps);

        fromAttrs = ps: fromNormalized (normalize ps);

      };
    };
}