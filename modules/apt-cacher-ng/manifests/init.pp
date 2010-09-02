class apt-cacher-ng {

  package { "apt-cacher-ng":
    ensure => present,
  }

  service { "apt-cacher-ng":
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => false,
    pattern => "/usr/sbin/apt-cacher-ng",
    require => Package["apt-cacher-ng"],
  }

  file {
    "/etc/apt-cacher-ng/pfilepattern.conf":
    content => 'PfilePattern = .*(\.deb|\.rpm|\.dsc|\.tar\.gz\.gpg|\.tar\.gz|\.diff\.gz|\.diff\.bz2|\.jigdo|\.template|changelog|copyright|\.udeb|\.diff/.*\.gz|\.gpg|\.key|\.exe|vmlinuz|initrd\.gz|ReleaseAnnouncement)$',
    require => Package["apt-cacher-ng"],
    notify => Service["apt-cacher-ng"];
  }

  file {
    "/etc/apt-cacher-ng/backends_debian":
      content => "http://debian.inode.at/debian/\n",
      notify => Service["apt-cacher-ng"];

    "/etc/apt-cacher-ng/backends_debvol":
      content => "http://debian.inode.at/debian-volatile/\n",
      notify => Service["apt-cacher-ng"];

    "/etc/apt-cacher-ng/backends_ubuntu":
      content => "http://ubuntu.inode.at/ubuntu/\n",
      notify => Service["apt-cacher-ng"];
  }            
  
}
