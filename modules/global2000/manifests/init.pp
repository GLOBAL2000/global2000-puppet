import "hacks.pp"

class global2000 {
  include "hacks::${lsbdistcodename}"

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

  package {
    "ruby-gnome2":
      ensure => present,
  }

  file {
    "firefox profile":
      path => $operatingsystemrelease ? {
        "9.10" => "/etc/firefox-3.5/profile",
        "10.04" => "/etc/firefox/profile",
      },
      source => "puppet:///global2000/firefox35-profile",
      recurse => true,
      purge => true,
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
    "/usr/local/share/applications":
      ensure => directory,
  }
  
  file {
    "/usr/local/share/applications/gleblication.desktop":
      source => "puppet:///global2000/gleblication.desktop",
      require => File["/usr/local/share/applications"],
  }

  file {
    "/etc/thunderbird/pref/thunderbird-file-links-anklickbar.js":
      source => "puppet:///global2000/thunderbird-file-links-anklickbar.js",
      require => Package["thunderbird"],
  }
}
