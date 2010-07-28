class notebook {
  include wlan

  file {
    "/etc/network/if-up.d/g2net":
      source => "puppet:///notebook/g2net.sh",
      mode => 755, owner => root, group => root,
  }

  get_by_rsync{ "krb5-auth-dialog.deb": }

  package {
    "libkrb5-25-heimdal":
      ensure => present,
  }
  
  package {
    "krb5-auth-dialog":
      ensure => present,
      source => "/var/tmp/krb5-auth-dialog.deb",
      require => [ Get_by_rsync["krb5-auth-dialog.deb"], Package["libkrb5-25-heimdal"] ],
      provider => 'dpkg';
  }

  gconf-system {
    "/apps/krb5-auth-dialog/plugins/enabled":
      preference => "mandatory",
      ensure => "[afs]",
      type => "list",
      list_type => "string",
      require => Package["krb5-auth-dialog"],
  }

  file {
    "/etc/xdg/autostart/krb5-auth-dialog.desktop":
      source =>  "puppet:///notebook/etc-xdg-autostart-krb5-auth-dialog.desktop",
      require => Package["krb5-auth-dialog"],
  }

  file {
    "/etc/NetworkManager/nm-system-settings.conf":
      source => "puppet:///notebook/etc-NetworkManager-nm-system-settings.conf",
  }

  exec {
    "pam-auth-update --remove krb5":
      require => Package["libpam-krb5"],
  }

}
