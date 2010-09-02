class dns-dhcp {
  include dns
  include dhcp
  
  class dns {
    package {
      "bind9":
        ensure => installed,
    }

    service {
      "bind9":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package["bind9"],
    }
    
    bind_zone {
      $bind_zones:
    }

    bind_zone_reverse {
      $bind_zones_reverse:
    }

    file {
      "/etc/bind/named.conf.local":
        content => template("dns-dhcp/named.conf.local.tpl"),
    }
  }

  class dhcp {
    $dhcp_path = "/etc/dhcp3"

    package {
      "dhcp3-server":
        ensure => installed,
    }

    service {
      "dhcp3-server":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => Package["dhcp3-server"],
    }
    
    file {
      "${dhcp_path}/dhcpd.conf":
        content => template("dns-dhcp/dhcpd.conf.tpl"),
    }

    file {
      "${dhcp_path}/fixed-address-hosts.conf":
        content => template("dns-dhcp/fixed-address-hosts.conf.tpl"),
    }
  }                  

}
