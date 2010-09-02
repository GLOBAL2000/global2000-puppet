# TFTP Subclass for PXE
class tftp {
  package {
    "tftpd-hpa":
      ensure => present,
      responsefile => "/etc/global2000-preseed-server.txt",
      require => File["/etc/global2000-preseed-server.txt"],
  }

  service {
    "tftpd-hpa":
      enable => true,
      ensure => running,
      pattern => "/usr/sbin/in.tftpd",
      require => Package["tftpd-hpa"],
  }

  file {
    "/var/lib/tftpboot":
      source => "puppet:///puppetserver/var-lib-tftpboot",
      recurse => true;

    "/var/lib/tftpboot/pxelinux.cfg":
      owner => root, group => root,
      mode => 777,
      require => File["/var/lib/tftpboot"],
      source => "puppet:///puppetserver/var-lib-tftpboot/pxelinux.cfg",
      recurse => true;
  }

  # Karmic
  exec {
    "wget karmic netboot tarball":
      cwd => "/var/tmp",
      command => "wget -O /var/tmp/netboot-karmic.tar.gz -c http://ubuntu.inode.at/ubuntu/dists/karmic/main/installer-i386/current/images/netboot/netboot.tar.gz",
      creates => "/var/tmp/netboot-karmic.tar.gz",
      require => Package["tftpd-hpa"],
  }

  exec {
    "unpack karmic netboot tarball":
      cwd => "/var/lib/tftpboot",
      command => "tar --transform 's/ubuntu-installer/karmic-installer/' -xzf /var/tmp/netboot-karmic.tar.gz ./ubuntu-installer/",
      creates => "/var/lib/tftpboot/karmic-installer",
      require => Exec["wget karmic netboot tarball"],
  }

  # Lucid
  exec {
    "wget lucid netboot tarball":
      cwd => "/var/tmp",
      command => "wget -O /var/tmp/netboot-lucid.tar.gz -c http://ubuntu.inode.at/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/netboot.tar.gz",
      creates => "/var/tmp/netboot-lucid.tar.gz",
      require => Package["tftpd-hpa"],
  }

  exec {
    "unpack lucid netboot tarball":
      cwd => "/var/lib/tftpboot",
      command => "tar --transform 's/ubuntu-installer/lucid-installer/' -xzf /var/tmp/netboot-lucid.tar.gz ./ubuntu-installer/",
      creates => "/var/lib/tftpboot/lucid-installer",
      require => Exec["wget lucid netboot tarball"],
  }

  # Squeeze
  exec {
    "wget squeeze netboot tarball":
      cwd => "/var/tmp",
      command => "wget -O /var/tmp/netboot-squeeze.tar.gz -c http://debian.inode.at/debian/dists/squeeze/main/installer-amd64/current/images/netboot/netboot.tar.gz",
      creates => "/var/tmp/netboot-squeeze.tar.gz",
      require => Package["tftpd-hpa"],
  }

  exec {
    "unpack squeeze netboot tarball":
      cwd => "/var/lib/tftpboot",
      command => "tar --transform 's/debian-installer/squeeze-installer/' -xzf /var/tmp/netboot-squeeze.tar.gz ./debian-installer/",
      creates => "/var/lib/tftpboot/squeeze-installer",
      require => Exec["wget squeeze netboot tarball"],
  }

}
