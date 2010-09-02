import "tftp.pp"

class puppetserver {
  include tftp
  include rsync_server
  
  package {
    ["syslinux", "thttpd", "puppetmaster", "rdoc", wakeonlan]:
      ensure => present,
  }

  package {
    puppet-el:
      ensure => latest,
      require => Package["emacs"],
  }

  service {
    "thttpd":
      enable => true,
      ensure => running,
      require => Package[thttpd],
  }

  file {
    "/etc/default/thttpd":
      content => "ENABLED=yes",
      notify => Service["thttpd"],
  }

  file {
    "/var/www":
      source => "puppet:///puppetserver/var-www",
      recurse => true,
  }

  file {
    "/usr/local/lib/site_ruby":
      source => "puppet:///puppetserver/site_ruby",
      recurse => true,
  }

  file {
    "/etc/ethers":
      source => "puppet:///puppetserver/etc-ethers",
  }

  file {
    "/usr/local/bin/g2-install-computer-with-mac.rb":
      mode => 744,
      source => "puppet:///puppetserver/g2-install-computer-with-mac.rb",
  }

  file {
    "/etc/puppet/fileserver.conf":
      source => "puppet:///puppetserver/etc-puppet/fileserver.conf",
  }

  file {
    "/var/lib/puppet/ssl":
      owner => puppet, group => puppet,
      source => "puppet:///puppetserver/var-lib-puppet-ssl",
      recurse => true,
      ensure => present,
      before => Package["puppetmaster"];
  }

  cron { clear-certs:
    command => "rm -f /var/lib/puppet/ssl/ca/signed/*.pem",
    user => root,
    hour => '*',
    minute => 0,
  } 
}
