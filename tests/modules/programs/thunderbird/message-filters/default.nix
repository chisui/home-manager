{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    accounts.email.accounts.testMail = {
      primary = true;
      userName = "test-user";
      realName = "Testi Mac Testface";
      address = "test@somewhere.org";
      smtp.host = "smtp.somewhere.org";
      imap.host = "imap.somewhere.org";
      thunderbird = {
        enable = true;
        filters = fx:
          with fx; {
            "some filter" = {
              condition = all [ "subject,contains,hello" ];
              actions = [ mark-read (move-to (imap-folder "some/folder")) ];
            };
          };
      };
    };
    programs.thunderbird = {
      enable = true;
      profiles.testProfile.isDefault = true;
    };

    nmt.script = ''
      assertFileContent \
        home-files/.thunderbird/testProfile/ImapMail/imap.somewhere.org/msgFilterRules.dat \
        ${./message-filters-expected.dat}
    '';
  };
}
