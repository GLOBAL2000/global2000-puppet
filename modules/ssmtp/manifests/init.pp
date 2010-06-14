class ssmtp {

  package { ssmtp:
    ensure => present,
  }

  file {	
    "/etc/ssmtp/ssmtp.conf":
      mode => 640, owner => root, group => mail,
      require => Package[ssmtp],
      content => template("ssmtp/etc-ssmtp-ssmtp.conf.erb"),
  }

}
