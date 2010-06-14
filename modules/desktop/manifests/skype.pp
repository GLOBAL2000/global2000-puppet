class desktop::skype {
 
  get_by_rsync { "skype.deb": }
  get_by_rsync { "skype-common.deb": }

  package {
    "skype deps":
      name => ["libqt4-dbus", "libqt4-network"],
      ensure => present;
  }
  
  package {
    "skype":
      ensure => present,
      source => "/var/tmp/skype.deb",
      require => [ Get_by_rsync["skype.deb"], Package["skype-common"] ],
      provider => 'dpkg';
      
    "skype-common":
      ensure => present,
      source => "/var/tmp/skype-common.deb",
      require => Get_by_rsync["skype-common.deb"],
      provider => 'dpkg';
  }

}
