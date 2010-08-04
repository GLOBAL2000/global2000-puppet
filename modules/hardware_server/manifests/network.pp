class hardware_server::network {

  class bridge {
    include network
    
    file {
      "/etc/network/interfaces":
        owner => root,
        group => root,
        mode => 644,
        content => template("hardware_server/bridge.erb"),
        require => Package["bridge-utils"],
    }

    package { "bridge-utils":
      ensure => present,
    }

  }

  class simple {
    include network
    
    file {
      "/etc/network/interfaces":
        owner => root,
        group => root,
        mode => 644,
        content => template("hardware_server/simple.erb"),
    }
    
  }
    
  file {
    "/etc/resolv.conf":
      owner => root,
      group => root,
      mode => 644,
      source => "puppet:///hardware_server/etc-resolv.conf",
  }

}
