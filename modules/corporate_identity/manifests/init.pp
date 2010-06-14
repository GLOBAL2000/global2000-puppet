class corporate_identity {
tag "systemstart"
  
  # for i in /usr/share/icons/Humanity/places/*/start-here.svg;do echo -n "\"$i\", ";done
  file {
    ["/usr/share/icons/Humanity/places/16/start-here.svg", "/usr/share/icons/Humanity/places/22/start-here.svg", "/usr/share/icons/Humanity/places/24/start-here.svg", "/usr/share/icons/Humanity/places/32/start-here.svg", "/usr/share/icons/Humanity/places/48/start-here.svg", "/usr/share/icons/Humanity/places/64/start-here.svg"]:
      backup => false,
      source => "puppet:///corporate_identity/start-here.svg",
  }

  file {
    "/usr/local/share/backgrounds":
      source => "puppet:///corporate_identity/desktop-backgrounds",
      recurse => true,
  }

  gconf-system {
    "/desktop/gnome/background/picture_filename":
      ensure => '/usr/local/share/backgrounds/seewinkel_cut.png',
      location => '/var/lib/gdm/.gconf.',
      require => File["/usr/local/share/backgrounds"],
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
