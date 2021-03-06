class apt-repositories {

  file {
    "/etc/apt/sources.list":
      content => '',
      tag => "debootstrap",
  }

  file {
    "/etc/apt/apt.conf.d/03aptproxy":
      tag => "debootstrap",
      content => "Acquire::http::Proxy \"http://${aptproxy}/\";\n",
  }

  file {
    "/etc/apt/apt.conf":
      ensure => absent,
      require => File["/etc/apt/apt.conf.d/03aptproxy"],
  }
 

  file {
    "/etc/apt/trusted.gpg":
      source => "puppet:///apt-repositories/${operatingsystem}-etc-apt-trusted.gpg",
      tag => "debootstrap",
      owner => root, group => root,
      mode => 600,
  }
  
  case $operatingsystem {
    Ubuntu: {
      file {
        "/etc/apt/sources.list.d/${lsbdistcodename}-sources.list":
          source => "puppet:///apt-repositories/${lsbdistcodename}-sources.list",
          tag => "debootstrap",
      }

      file {
        "/etc/apt/sources.list.d/${lsbdistcodename}-medibuntu.list":
          source => "puppet:///apt-repositories/${lsbdistcodename}-medibuntu.list",
          tag => "debootstrap",
      }

      file {
        "/etc/apt/apt.conf.d/20auto-upgrades":
          content => "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n"
      }
      
      file {
        "/etc/apt/apt.conf.d/50unattended-upgrades":
          content => "Unattended-Upgrade::Allowed-Origins { \"Ubuntu ${lsbdistcodename}-security\"; \"Ubuntu ${lsbdistcodename}-updates\"; };\n",
      }

      file {
        "/etc/apt/sources.list.d/opera.list":
          source => "puppet:///apt-repositories/opera.list",
      }

    }
    
    "Debian": {
      file {
        "/etc/apt/sources.list.d/openprinting-sources.list":
          content => "deb http://www.openprinting.org/download/printdriver/debian/ lsb3.2 main";
        
        "/etc/apt/sources.list.d/foswiki.list":
          content => "deb http://fosiki.com/Foswiki_debian/ stable main contrib \ndeb-src http://fosiki.com/Foswiki_debian/ stable main contrib";
      }

      case $operatingsystemrelease {
        "squeeze/sid": {
          file {
            "/etc/apt/sources.list.d/debian-sources.list":
              source => "puppet:///apt-repositories/debian-squeeze-sources.list",
              tag => "debootstrap";
          }
        }
        /(5.0.*)/: {
          file {
            "/etc/apt/sources.list.d/debian-sources.list":
              source => "puppet:///apt-repositories/debian-lenny-sources.list",
              tag => "debootstrap";

            "/etc/apt/sources.list.d/backports.list":
              content => "deb http://debian.inode.at/backports/ lenny-backports main contrib non-free";

            "/etc/apt/sources.list.d/3ware-3dm2.list":
              content => "deb http://jonas.genannt.name/debian lenny restricted";
          }
        }
      }
    }
  }

}

