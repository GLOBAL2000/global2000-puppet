import "definitions"

##Zones
import "g2zone"

##Roles
class minimal {
  include users::root
  file { "/etc/motd.tail": content => "Machine Puppet-Managed\n" }

  file {
    "/etc/global2000-preseed.txt":
      source => "puppet:///files/global2000-preseed.txt"
  }

  file {
    "/etc/global2000-preseed-server.txt":
      source => "puppet:///files/global2000-preseed-server.txt"
  }

  # a Debian default that sucks
  host { $fqdn: 
    ensure => absent,
  }

}

class general {
  include minimal
  include andis-admintools
  include puppetclient
  include apt-repositories
  k5login{ "/root/.k5login": principals => $server_admins }
}

## Special nodes for testing purposes

node bleedingedge inherits g2zone {
  include adminscripts
  include general
}

node /seewinkel45/ inherits bleedingedge {
}

node 'throwaway' inherits g2zone {  
  include puppetclient
}

##Nodes
node default {}

node /seewinkel.*/ inherits g2zone {
  include general
  include global2000
  include corporate_identity
  include desktop
  include autofs::clients
  include purges
  include kerberize
  include clientauth::pam
  include clientauth::ldap
  include afsclient
  include puppet-standalone
  include ntpclient
  case $environment { debootstrap: { include debootstrap } }
}

node 'ldap1', 'ldap2' inherits g2zone {
  include general
  include kerberize
  include ldapserver
}

node 'wiki' inherits g2zone {
  include general
  include kerberize
  include apache
  include foswiki
}

node 'bugs' inherits g2zone {
  include general
  include kerberize
  include apache
  include apache::mysql
  include apache::ssl
  include redmine
}

node 'sustain' inherits g2zone {
  include general
  include autofs::sustain
  include acl
  include users::sustain
}

node 'groupoffice' inherits g2zone {
  include general
  include kerberize
  include apache
  include apache::php
  include apache::mysql
  include apache::ssl
  include groupoffice_data
}

node 'kerberos1' inherits g2zone {
  include general
  include kerberize
  include krb5-admin-server
}

node 'cups' inherits g2zone {
  include general
  include kerberize
  include cups_server
  include clientauth::ldap
  include clientauth::pam
}

node 'airbus' inherits g2zone {
  include general
  include kerberize
  include clientauth::ldap
  include fileserver
  include hardware_server::airbus
  include acl
  include ntpclient
}

node 'puppet' inherits g2zone {
  $daemonize_puppet_client = false
  include general
  include puppetserver
  include kerberize
}

node 'nagual' inherits g2zone {
  include general
  include kerberize
  include apache
  include apache::php
  include apache::mysql
}

node 'fuckup' inherits g2zone {
  $daemonize_puppet_client = false
  include hardware_server::fuckup
  include kerberize
  include general
  include ssmtp
  include afsclient
  include smart
}

node 'aptproxy' inherits g2zone {
  include general
  include kerberize
  include apt-cacher-ng
}
