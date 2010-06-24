class gnome_panel::karmic {
  # for i in /usr/share/icons/Humanity/places/*/start-here.svg;do echo -n "\"$i\", ";done
  file {
    ["/usr/share/icons/Humanity/places/16/start-here.svg", "/usr/share/icons/Humanity/places/22/start-here.svg", "/usr/share/icons/Humanity/places/24/start-here.svg", "/usr/share/icons/Humanity/places/32/start-here.svg", "/usr/share/icons/Humanity/places/48/start-here.svg", "/usr/share/icons/Humanity/places/64/start-here.svg"]:
      backup => false,
      source => "puppet:///corporate_identity/start-here.svg",
  }

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

class gnome_panel::lucid {

}
