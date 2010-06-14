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
    "/var/lib/puppet":
      owner => puppet, group => puppet,
      source => "puppet:///puppetserver/var-lib-puppet",
      recurse => true,
      ensure => present,
      before => Package["puppetmaster"];

    "/var/lib/puppet/ssl/private_keys/puppet.g2.pem":
      owner => root, group => root,
      mode => 600,
      require => File["/var/lib/puppet"];
  }
  
}
