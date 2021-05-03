{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    accounts.email.accounts = {
      prime = {
        primary = true;
        userName = "test-user";
        realName = "Testi Mac Testface";
        address = "test@somewhere.org";
        smtp.host = "smpt.somewhere.org";
        imap.host = "imap.somewhere.org";
        thunderbird.enable = true;
      };
      sec = {
        userName = "some-user";
        realName = "Samy Mac Someface";
        address = "some@somewhere.org";
        smtp.host = "smpt.somewhere.org";
        imap.host = "imap.somewhere.org";
        thunderbird.enable = true;
      };
    };
    programs.thunderbird = {
      enable = true;
      profiles.testProfile.isDefault = true;
    };

    nmt.script = ''
      assertFileContent \
        home-files/.thunderbird/testProfile/user.js \
        ${./expected.user.js}
    '';
  };
}
