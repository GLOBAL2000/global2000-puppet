class ntp {

  class client {
    include ntpservice
    
    file {
      "/etc/ntp.conf":
        content => "server $ntpserver\n",
        require => Package["ntp"],
    } 
  }

  class server {
    include ntpservice

    file {
      "/etc/ntp.conf":
        source => "puppet:///ntp/ntp-server.conf",
        require => Package["ntp"],
    }
  }

  class ntpservice {
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
  }

}
