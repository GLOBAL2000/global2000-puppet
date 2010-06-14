class smart {

  package { "smartmontools":
    ensure => present,
  }

  service { "smartmontools":
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => false,
    require => Package["smartmontools"],
    pattern => "/usr/sbin/smartd",
  }

  file { "/etc/default/smartmontools":
    require => Package["smartmontools"],
    content => "start_smartd=yes\n",
  }

  file { "/etc/smartd.conf":
    require => Package["smartmontools"],
    content => "DEVICESCAN -m ${contactemail}\n",
    notify => Service["smartmontools"],
  }
  
}
