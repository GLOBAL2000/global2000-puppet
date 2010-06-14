class puppetclient {

  package {
    "lsb-release":
      ensure => present,
  }
  
  package {
    "puppet":
      ensure => present;
  }
  
  service {
    "puppet":
      ensure => $daemonize_puppet_client ? {
        true => "running",
        false => "stopped",
      },
      enable => $daemonize_puppet_client ? {
        true => "true",
        false => "false",
      },
      hasrestart => true,
      status => "start-stop-daemon -t -p /var/run/puppet/puppetd.pid --stop",
      require => Package[puppet],
  }
  
  file {
    "/etc/puppet/puppet.conf":
      tag => "debootstrap",
      mode => 644, owner => root, group => root,
      require => Package[puppet],
      ensure => present,
      content => template("puppetclient/puppet.conf.erb"),
      notify  => Service["puppet"],
  }

  file {
    "/etc/default/puppet":
      content => template("puppetclient/etc-default-puppet.erb"),
      require => Package[puppet],
  }

}
