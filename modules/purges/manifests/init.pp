class purges {

  package { ["ubuntuone-client", "python-ubuntuone-client", "ubuntuone-client-gnome", modemmanager, wpasupplicant]:
    ensure => purged,
  }
  
  service {
    "network-manager":
      enable => false,
      ensure => stopped,
      pattern => "NetworkManager",
  }
  
  service {
    "avahi-daemon":
      enable => false,
      ensure => stopped,
      stop => "service avahi-daemon stop",
      require => File["/etc/init.d/avahi-daemon"],
  }

  file {
    "/etc/init.d/avahi-daemon":
      ensure => absent,
  }

  service {
    "cups":
      enable => false,
      ensure => stopped,
  }
  
  file { "/etc/xdg/autostart/nm-applet.desktop":
    ensure => absent,
  }
  
  file { "/etc/xdg/autostart/update-notifier.desktop":
    ensure => absent,
  }
  
  file { "/etc/xdg/autostart/indicator-applet.desktop":
    ensure => absent,
  }
  
  file { "/etc/xdg/autostart/jockey-gtk.desktop":
    ensure => absent,
  }

  file { "/etc/xdg/autostart/evolution-alarm-notify.desktop":
    ensure => absent,
  }

  gconf-system {
    "/desktop/gnome/sound/event_sounds":
      type => bool,
      ensure => false,
      preference => mandatory,
  }

  file {
    "/etc/modprobe.d/blacklist-pcspkr.conf":
      tag => debootstrap,
      content => "blacklist pcspkr\n",
  }

}
