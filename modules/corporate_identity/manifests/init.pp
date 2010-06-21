class corporate_identity {
  tag "systemstart"
  include gnome_panel

  file {
    "/usr/share/gdm/autostart/LoginWindow/gastuser.desktop":
      tag => "systemstart",
      source => "puppet:///corporate_identity/gastuser.desktop",
  }

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
      
  class gnome_panel {
    gconf-system {
      "/apps/panel/default_setup/objects/thunderbird_launcher/launcher_location":
        ensure => "thunderbird.desktop",
    }

    gconf-system {
      "/apps/panel/default_setup/objects/thunderbird_launcher/object_type":
        ensure => "launcher-object",
    }
    
    gconf-system {
      "/apps/panel/default_setup/objects/thunderbird_launcher/toplevel_id":
        ensure => "top_panel",
    }

    gconf-system {
      "/apps/panel/default_setup/objects/thunderbird_launcher/position":
        type => "integer",
        ensure => 2,
    }

    gconf-system {
      "/apps/panel/default_setup/general/object_id_list":
        type => 'list --list-type=string',
        ensure => '[thunderbird_launcher,browser_launcher,menu_bar]',
    }

    gconf-system {
      "/apps/panel/default_setup/general/applet_id_list":
        type => 'list --list-type=string',
        ensure => '[clock,notification_area,show_desktop_button,window_list,workspace_switcher,trashapplet,fast_user_switch]',
    }
  }
}


