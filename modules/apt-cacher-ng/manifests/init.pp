class apt-cacher-ng {

  package { "apt-cacher-ng":
    ensure => present,
  }

  service { "apt-cacher-ng":
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => false,
    pattern => "/usr/sbin/apt-cacher-ng",
    require => Package["apt-cacher-ng"],
  }

}
