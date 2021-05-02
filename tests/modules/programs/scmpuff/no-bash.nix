{ pkgs, ... }: {
  config = {
    programs = {
      scmpuff = {
        enable = true;
        enableBashIntegration = false;
      };
      bash.enable = true;
    };

    nmt.script = ''
      assertFileNotRegex home-files/.bashrc '${pkgs.gitAndTools.scmpuff}/bin/scmpuff'
    '';
  };
}
