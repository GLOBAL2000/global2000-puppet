class kerberize::krb {

  package {
    "libpam-krb5":
      ensure => present,
  }
  
  file {
    "/etc/krb5.conf":
      content => template("kerberize/krb5.conf.tpl"),
  }
  
  package {
    "krb5-user":
      ensure => present,
      responsefile => "/etc/global2000-preseed.txt",
      require => File["/etc/global2000-preseed.txt"],
  }
 
}

class kerberize {
  include krb
  
  service {
    "ssh":
      ensure => running,
      enable => true,
      pattern => "/usr/sbin/sshd",
      subscribe => File["/etc/ssh/sshd_config"],
  }

  file {
    "/etc/ssh/sshd_config":
      source => "puppet:///kerberize/sshd_config",
      require => [ File["/etc/krb5.keytab"], Package["krb5-user"] ]
  }
  
  file {
    "/etc/ssh/ssh_config":
      source => "puppet:///kerberize/ssh_config",
  }
  
  file {
    "/etc/krb5.keytab":
      owner => "root",
      mode => "600",
      source => "puppet:///kerberize/keytabs/host.${hostname}.g2.keytab",
  }

  file {
    "/root/.k5login":
      owner => root,
      mode => 644,
      ensure => present,
  }
  
}
