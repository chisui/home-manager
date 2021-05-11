args:

rec {
  dag =
    let
      d = import ./dag.nix args;
    in
      {
        empty = d.emptyDag;
        isDag = d.isDag;
        topoSort = d.dagTopoSort;
        map = d.dagMap;
        entryAnywhere = d.dagEntryAnywhere;
        entryBetween = d.dagEntryBetween;
        entryAfter = d.dagEntryAfter;
        entryBefore = d.dagEntryBefore;
      };

  gvariant = import ./gvariant.nix args;
  maintainers = import ./maintainers.nix;
  strings = import ./strings.nix args;
  types = import ./types.nix (args // { inherit dag gvariant; });

  shell = import ./shell.nix args;
  zsh = import ./zsh.nix args;
  mozilla = import ./mozilla.nix args;
}
