class global2000 {

  file {
    "/etc/cups/client.conf":
      mode => 644, owner => root, group => root,
      content => "ServerName $printserver\n"
  }

  # Für IBM Rechner. Nur machen wenn Device vorhanden und noch nicht eingeschaltet.
  exec {
    "mono einschalten": 
      command => "amixer -q cset iface=MIXER,name='Master Mono Playback Volume' 90% && amixer -q cset iface=MIXER,name='Master Mono Playback Switch' on",
      unless => "amixer cget iface=MIXER,name='Master Mono Playback Switch' 2>&1 | egrep -q \"Cannot find the given element from control default|values=on\"",
  }
  
  exec {
    "umask setzen":
      tag => "systemstart",
      path => "/bin",
      command => "sed --in-place -e 's/^umask .*/umask ${global2000_umask}/' /etc/profile",
      unless => "grep --quiet 'umask ${global2000_umask}' /etc/profile",
  }

  # Hässlicher hässlicher hack der noch weg muss!!!
  exec {
    "repair grub":
      tag => ["debootstrap", "hack"],
      command => "sed --in-place -e 's/\\(^\s*echo \"search --no-floppy --fs-uuid --set \${fs_uuid}\"\\)/true #\\1/' /usr/lib/grub/grub-mkconfig_lib",
      unless => "grep --quiet '^true #\s*echo \"search --no-floppy' /usr/lib/grub/grub-mkconfig_lib",
      notify => Exec["update-grub"],
  }
  
  exec {
    "update-grub":
      tag => ["debootstrap", "hack"],
      onlyif => "grep --quiet 'search --no-floppy' /boot/grub/grub.cfg",
  }
      
  file { "/etc/gdm/custom.conf":
    tag => debootstrap,
    source => "puppet:///global2000/gdm.conf-custom",
  }

  file { "/etc/default/console-setup":
    tag => debootstrap,
    source => "puppet:///global2000/etc-default-console-setup",
  }

  package {
    "ruby-gnome2":
      ensure => present,
  }


  file {
    "/etc/firefox-3.5/profile":
      source => "puppet:///global2000/firefox35-profile",
      recurse => true,
      purge => true,
  }

  file {
    "/usr/share/gdm/autostart/LoginWindow/gastuser.desktop":
      tag => "systemstart",
      source => "puppet:///global2000/gastuser.desktop",
  }

  file {
    "/etc/dhcp3/dhclient.conf":
      content => template("global2000/etc-dhcp3-dhclient.conf.erb"),
  }

  file {
    "/etc/skel":
      tag => "systemstart",
      recurse => true,
      source => "puppet:///global2000/skel",
  }

  file {
    "lokale reset-skripts":
      tag => "systemstart",
      path => "/usr/local/bin",
      source => "puppet:///global2000/reset-skripts",
      recurse => true,
  }

  file {
    "/etc/X11/Xsession.d/42global2000_cleanups":
      tag => "systemstart",
      source => "puppet:///global2000/Xsessiond-42global2000_cleanups",
  }

  file {
    "/usr/local/bin/gleblication.rb":
      owner => "root", group => "root", mode => 755,
      source => "puppet:///global2000/gleblication.rb",
  }

  file {
    "/usr/local/share/pixmaps":
      ensure => directory,
  }

  file {
    "/usr/local/share/pixmaps/gleblication.png":
      source => "puppet:///global2000/gleblication.png",
      require => File["/usr/local/share/pixmaps"],
  }

  file {
    "/usr/local/share/applications/gleblication.desktop":
      source => "puppet:///global2000/gleblication.desktop",
  }

  file {
    "/etc/thunderbird/pref/thunderbird-file-links-anklickbar.js":
      source => "puppet:///global2000/thunderbird-file-links-anklickbar.js",
      require => Package["thunderbird"],
  }
}
