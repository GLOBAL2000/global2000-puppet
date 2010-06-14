class ntpclient {

  package { ntp:
    ensure => present,
  }

  service { ntp:
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => Package["ntp"],
    subscribe => File["/etc/ntp.conf"],
  }

  file {
    "/etc/ntp.conf":
      content => "server $ntpserver\n",
      require => Package["ntp"],
  } 

}
