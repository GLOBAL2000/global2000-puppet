class gdm::common {
  file {
    "/usr/local/share/backgrounds":
      source => "puppet:///corporate_identity/desktop-backgrounds",
      recurse => true,
  }

  file { "/etc/gdm/custom.conf":
    tag => debootstrap,
    source => "puppet:///corporate_identity/gdm.conf-custom",
  }
      
  gconf {
    "/apps/gdm/simple-greeter/banner_message_text":
      ensure => "Willkommen bei GLOBAL2000",
      location => '/var/lib/gdm/.gconf.',
  }
      
  gconf {
    "/apps/gdm/simple-greeter/banner_message_enable":
      ensure => true,
      type => 'boolean',
      location => '/var/lib/gdm/.gconf.',
  }
      
  gconf {
    "/apps/gdm/simple-greeter/logo_icon_name":
      ensure => 'start-here',
      location => '/var/lib/gdm/.gconf.',
  }
}

class gdm::karmic inherits gdm::common {
  file {
    "/usr/share/gdm/autostart/LoginWindow/gastuser.desktop":
      tag => "systemstart",
      source => "puppet:///corporate_identity/gastuser.desktop",
  }

  gconf {
    "/desktop/gnome/background/picture_filename":
      ensure => '/usr/local/share/backgrounds/seewinkel_cut.png',
      location => '/var/lib/gdm/.gconf.',
      require => File["/usr/local/share/backgrounds"],
  }
}

class gdm::lucid inherits gdm::common {
  $gdm_guest_user_try_icon_command = 'zenity --notification --text=Gastuser --window-icon=/usr/share/icons/Humanity/emblems/24/emblem-OK.png'

  file {
    "/usr/share/gdm/autostart/LoginWindow/gastuser.desktop":
      tag => "systemstart",
      content => template("corporate_identity/gastuser.desktop.erb");

    "/etc/gdm/PostLogin/Default":
      owner => "root",
      group => "root",
      mode => 755,
      content => "#!/bin/sh
pkill -f '$gdm_guest_user_try_icon_command'\n",
  }


}
