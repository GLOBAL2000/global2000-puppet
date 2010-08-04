class dns-dhcp {
  include dns
  include dhcp
  
  class dns {
    bind-zone {
      $bind_zones:
    }

    bind-zone-reverse {
      $bind_zones_reverse:
    }

    file {
      "/etc/bind/named.conf.local":
        content => template("dns-dhcp/named.conf.local.tpl"),
    }
  }

  class dhcp {
    $dhcp_path = "/etc/dhcp3"

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
