class gdm::karmic {
  file {
    "/usr/local/share/backgrounds":
      source => "puppet:///corporate_identity/desktop-backgrounds",
      recurse => true,
  }

  file {
    "/usr/share/gdm/autostart/LoginWindow/gastuser.desktop":
      tag => "systemstart",
      source => "puppet:///corporate_identity/gastuser.desktop",
  }

  gconf-system {
    "/desktop/gnome/background/picture_filename":
      ensure => '/usr/local/share/backgrounds/seewinkel_cut.png',
      location => '/var/lib/gdm/.gconf.',
      require => File["/usr/local/share/backgrounds"],
  }

  file { "/etc/gdm/custom.conf":
    tag => debootstrap,
    source => "puppet:///corporate_identity/gdm.conf-custom",
  }
      
  gconf-system {
    "/apps/gdm/simple-greeter/banner_message_text":
      ensure => "Willkommen bei GLOBAL2000",
      location => '/var/lib/gdm/.gconf.',
  }
      
  gconf-system {
    "/apps/gdm/simple-greeter/banner_message_enable":
      ensure => true,
      type => 'boolean',
      location => '/var/lib/gdm/.gconf.',
  }
      
  gconf-system {
    "/apps/gdm/simple-greeter/logo_icon_name":
      ensure => 'start-here',
      location => '/var/lib/gdm/.gconf.',
  }
}

class gdm::lucid {

}
