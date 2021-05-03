{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    accounts.email.accounts.testUser = {
      thunderbird.enable = true;
      userName = "test-user";
      smtp = {
        host = "smpt.somewhere.org";
      }; 
      imap = {
        host = "imap.somewhere.org";
      }; 
    };
    programs.thunderbird = {
      enable = true;
      profiles.testUser.isDefault = true;
    };

    nmt.script = ''
      assertFileContent \
        home-files/.thunderbird/testUser/ImapMail/mail.somewhere.net/msgFilterRules.dat \
        ${./message-filters-expected.dat}
    '';
  };
}
