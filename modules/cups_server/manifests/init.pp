class cups_server {

  include ssmtp
  
  package {
    "cups":
      ensure => present,
      require => Package["ssmtp"],
  }

  file { "/etc/default/cups":
    mode => 644, owner => root, group => root,
    require => [ Package["cups"], File["/etc/cups/HTTP.cups.g2.keytab"] ],
    content => "LOAD_LP_MODULE=yes\nKRB5CCNAME=/etc/cups/HTTP.cups.g2.keytab\n",
    notify => Service["cups"],
  }

  file { "/etc/cups/HTTP.cups.g2.keytab":
    require => Package["cups"],
    source => "puppet:///cups_server/HTTP.cups.g2.keytab",
  }

  service { cups:
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => Package["cups"],
    subscribe => File["/etc/cups/cupsd.conf"],
  }

  file {
    "/etc/cups/cupsd.conf":
      require => Package["cups"],
      source => "puppet:///cups_server/etc-cups-cupsd.conf",
  }

  file {
    "/etc/cups/ppd/":
      owner => root, group => lp, mode => 755,
      source => "puppet:///cups_server/global2000_ppds/",
      require => Package["cups"],
  }

  package {
    ["avahi-daemon","avahi-utils","libnss-mdns"]:
      ensure => purged,
  }
}
