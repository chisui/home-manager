{ lib, ... }:

with lib;

let
  
  filterFlags = {
    before-junk = 1;
    manually = 16;
    after-junk = 32;
    after-sending = 64;
    archiving = 128;
    every-10-min = 256;
  };

  mkDat = let
    toDatVal = val:
      if isBool val then (if val then "yes" else "no") else toString val;
    mkLine = mapAttrsToList (key: val:
      optional (val != null) ''
        ${key}="${toDatVal val}"
      '');
  in d: concatStrings (flatten (concatMap mkLine d));

  mkFilters = { mail, host, filters }@account:
    let
      filtersCfg = filters (msgFiltersLib account);

      mkAction = { action, actionValue }:
        ([{ inherit action; }]
          ++ (optional (actionValue != null) { inherit actionValue; }));

      mkFilter = { name, enable, when, actions, condition }:
        ([
          { inherit name; }
          { inherit enabled; }
          { type = foldl' (a: b: a + b) 0 (when filterFlags); }
        ] ++ (concatMap mkAction actions)
          ++ [{ inherit condition; }]);

      msgFilterHeader = [ { version = 9; } { logging = false; } ];
    in mkDat (msgFilterHeader ++ (concatMap mkFilter filtersCfg));

in {
  inherit filterFlags;

  msgFiltersLib = { mail, host }:
    let
      # should work be enough for most mail addresses
      escapedMail = replaceChars [ "@" ] [ "%40" ] mail;
      conditions = op: cx: concatStringsSep " " (map (c: "${op} (${c})") cx);
      mkAction = action: actionValue: { inherit action actionValue; };
      mkFolder = pre: dir: "${pre}/${dir}";
    in {
      mark-read = mkAction "Mark read" null;
      move-to = mkAction "Move to folder";
      copy-to = mkAction "Copy to folder";
      imap-folder = mkFolder "imap://${escapedMail}@${host}";
      local-folder = mkFolder "mailbox://nobody@Local%20Folders/";
      forward-to = mkAction "Forward";
      change-priority = mkAction "Change priority";
      all = conditions "AND";
      any = conditions "OR";
    };
}
