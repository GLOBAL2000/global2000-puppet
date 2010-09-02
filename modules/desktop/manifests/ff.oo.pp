class desktop::firefox {
  get_by_rsync { "firefox-addons/":
    destination => "/usr/lib/firefox-addons",
  }
}

class desktop::openoffice {
  get_by_rsync {
    "oo-extensions":
  }

  exec { "Install OpenOffice Extensions":
    command => "unopkg add --shared /var/tmp/oo-extensions/*",
  }
}
