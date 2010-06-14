class afsclient {

  package {
    "libpam-openafs-session":
      ensure => present,
  }

  package { ["openafs-client","openafs-krb5","openafs-modules-source"]:
    ensure => present,
    require => File["/etc/global2000-preseed.txt"],
  }

  case $operatingsystemrelease {
    /(5.0.*)/: {
      # For lenny this does not exist. :(
    }
    default: {
      package { "openafs-modules-dkms":
        ensure => present,
        require => Package["openafs-modules-source","openafs-client"],
      }
    }
  }

  file {	
    "/etc/openafs/afs.conf.client":
      mode => 644, owner => root, group => root,
      require => Package["openafs-client"],
      source => "puppet:///afsclient/etc-openafs-afs.conf.client",
  }

  file {	
    "/etc/openafs/cacheinfo":
      mode => 644, owner => root, group => root,
      require => Package["openafs-client"],
      content => "/afs:/var/cache/openafs:500000\n",
  }

  file {	
    "/etc/openafs/ThisCell":
      mode => 644, owner => root, group => root,
      require => Package["openafs-client"],
      content => "$afsrealm\n",
  }

  file {	
    "/etc/openafs/CellServDB":
      mode => 644, owner => root, group => root,
      require => Package["openafs-client"],
      content => ">$afsrealm\t#GLOBAL2000 - FOE Europe\n${afsserver_ip}\t#${afsserver_hostname}\n",
  }

  service { "openafs-client":
    ensure => running,
    enable => true,
    hasstatus => false,  
    pattern => "/sbin/afsd",
    hasrestart => true,
    require => Package["openafs-client"],
  }

}
