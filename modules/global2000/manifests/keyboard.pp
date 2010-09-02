class global2000::keyboard {
  file { "/etc/default/console-setup":
    tag => debootstrap,
    source => "puppet:///global2000/etc-default-console-setup",
  }

  case $distcodename {
    lucid: {
      exec {
        "keyboardlayout de":
          command => "/usr/bin/ckbcomp -model pc105 -layout de -option grp:alts_toggle,ctrl:nocaps,grp_led:scroll,keypad:oss,compose:rwin |gzip -9 > /etc/console-setup/cached.kmap.gz",
          creates => "/etc/console-setup/cached.kmap.gz";
      }

    }
  }
}
