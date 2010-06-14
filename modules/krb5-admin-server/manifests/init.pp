class krb5-admin-server {

  package {
    "krb5-admin-server":
      ensure => present,
      responsefile => "/etc/global2000-preseed.txt",
      require => File["/etc/global2000-preseed.txt"],
  }
  
  service {
    "krb5-admin-server":
      ensure => running,
      enable => true,
      require => Package["krb5-admin-server"],
  }
  
  service {
    "krb5-kdc":
      ensure => running,
      enable => true,
      require => Package["krb5-admin-server"],
  }
  
  file {
    "/etc/krb5kdc/kdc.conf":
      mode => 644, owner => root, group => root,
      source => "puppet:///krb5-admin-server/global2000.kdc.conf",
      require => Package["krb5-admin-server"],
      notify => [Service["krb5-admin-server"], Service["krb5-kdc"]],
  }

  file {
    "/etc/krb5kdc/kadm5.acl":
      mode => 644, owner => root, group => root,
      content => template("krb5-admin-server/etc-krb5kdc-kadm5.acl.erb"),
  }
}
