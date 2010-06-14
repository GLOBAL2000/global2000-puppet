class ldapserver {

  file {
    "/etc/populateldap":
      owner => "root",
      group => "root",
      mode => 600,
      source => "puppet:///ldapserver/etc-populateldap",
      recurse => true,
  }

  file {
    "populateldap-skripte":
      owner => "root",
      group => "root",
      mode => 700,
      path => "/usr/local/bin",
      source => "puppet:///ldapserver/bin-skripte",
      recurse => true,
  }

  file {
    "/usr/share/slapd/DB_CONFIG":
      source => "puppet:///ldapserver//usr-share-slapd-DB_CONFIG",
      require => Package["slapd"],
  }
  
  file {
    "/etc/default/slapd":
      content => template("ldapserver/etc-default-slapd.erb"),
      require => Package["slapd"],
      notify => Service["slapd"],
  }

  file {
    "/etc/ldap/slapd.conf":
      content => template("ldapserver/etc-ldap-slapd.conf.erb"),
      require => Package["slapd"],
      notify => Service["slapd"],
  }

  file {
    "/etc/ldap/ldap.conf":
      content => "BASE dc=global2000,dc=at\n",
      require => Package["slapd"],
  }

  file {
    "/etc/ldap/ldap.${fqdn}.keytab":
      owner => "openldap",
      group => "openldap",
      mode => 400,
      source => "puppet:///ldapserver/ldap.${fqdn}.keytab",
      require => Package["slapd"],
  }
    
  
  package {
    "slapd":
      ensure => installed,
      responsefile => "/etc/global2000-preseed.txt",
      require => File["/etc/global2000-preseed.txt"],
  }

  package {
    ["libsasl2-modules-gssapi-mit", "ldap-utils"]:
      ensure => installed,
      require => Package["slapd"],
  }

  service { slapd:
    name => $operatingsystem ? {
      debian  => "slapd",
      default => "slapd",
      },
      ensure => running,
      enable => true,
      pattern => $operatingsystem ? {
        debian  => "/usr/sbin/slapd",
        default => "/usr/sbin/slapd",
        },
        hasrestart => true,
        require => Package["slapd"],
  }
  
}
