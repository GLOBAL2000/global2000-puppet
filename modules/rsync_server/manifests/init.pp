class rsync_server {

  service { rsync:
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => [ Package["rsync"], File["/etc/default/rsync"], File["/etc/rsyncd.conf"] ],
  }

  file {	
    "/etc/default/rsync":
      mode => 644, owner => root, group => root,
      require => Package[rsync],
      content => "RSYNC_ENABLE=true",
      notify => Service["rsync"],
  }

  file { "/etc/rsyncd.conf":
    content => "[rsync]\npath=/home/rsync\ncomment=rsync for puppet\n",
    require => [ Package[rsync], File["/home/rsync"] ],
  }

  file { "/home/rsync":
    ensure => directory,
  }

}
