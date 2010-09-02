import "network.pp"

class hardware_server {
  class airbus {
    $ip = $airbus_ip
    include hardware_server::network::bridge
    include wake_fuckup
    
    file {
      "/etc/fstab":
        owner => root,
        group => root,
        mode => 644,
        source => "puppet:///hardware_server/airbus/etc-fstab",
    }

    file {
      "/etc/3dm2/3dm2.conf":
        owner => root,
        group => root,
        mode => 644,
        source => "puppet:///hardware_server/airbus/etc-3dm2.conf",
        subscribe => Service["3dm2"],
    }

    service { 3dm2:
      name => "3dm2",
      ensure => running,
      enable => true,
      pattern => "/usr/sbin/3dm2",
      hasrestart => true,
      hasstatus => false,
    }

    package { "bc":
      ensure => present,
    }

    package { "3ware-3dm2-binary":
      ensure => present,
    }
  }

  class fuckup {
    $ip = $fuckup_ip
    include hardware_server::network::simple

    file {
      "/usr/local/bin/backup.sh":
        owner => root, group => root, mode => 770,
        source => "puppet:///hardware_server/fuckup/backup.sh",
    }

    file {
      "/usr/local/bin/bury_account.sh":
        owner => root, group => root, mode => 770,
        source => "puppet:///hardware_server/fuckup/bury_account.sh",
    }

    file {
      "/root/mrbackupuserhimself.keytab":
        owner => root, group => root, mode => 400,
        source => "puppet:///hardware_server/fuckup/mrbackupuserhimself.keytab",
    }

    file {
      "/root/includes_dbserver":
        owner => root, group => root, mode => 400,
        source => "puppet:///hardware_server/fuckup/includes_dbserver",
    }
    
    cron { do-backup:
      command => "/usr/local/bin/backup.sh",
      user => root,
      hour => 22,
      minute => 00,
    }

    file {
      "/media/prpserver/":
        ensure => directory;
      "/media/dbserver/":
        ensure => directory;

      "/mnt/modo/":
        ensure => directory;
      "/mnt/difr/":
        ensure => directory;
      "/mnt/misa/":
        ensure => directory;
      "/mnt/so1":
        ensure => directory;
      "/mnt/so2":
        ensure => directory;
      "/mnt/friedhof":
        ensure => directory;
    }


    mount { "/mnt/modo/":
      device => "UUID=c3296d28-323f-461b-8c4d-da73b8f5ea89",
      fstype => ext3,
      ensure => mounted,
      options => "defaults",
      require => File["/mnt/modo"],
    }

    mount { "/mnt/difr/":
      device => "UUID=536eedad-81f0-4aef-983c-1c5bc8514771",
      fstype => ext3,
      ensure => mounted,
      options => "defaults",
      require => File["/mnt/difr"],
    }
    
    mount { "/mnt/misa/":
      device => "UUID=964ff816-dc8c-4ca5-b551-b82337135ec5",
      fstype => ext3,
      ensure => mounted,
      options => "defaults",
      require => File["/mnt/misa"],
    }

    mount { "/mnt/so1/":
      device => "UUID=f3cc2ea6-f95d-48cc-b7a3-622ba04b0119",
      fstype => ext3,
      ensure => mounted,
      options => "defaults",
      require => File["/mnt/so1"],
    }

    mount { "/mnt/so2/":
      device => "UUID=2cf9f70d-9f99-4265-bf62-ac7e5092cfd6",
      fstype => ext3,
      ensure => mounted,
      options => "defaults",
      require => File["/mnt/so2"],
    }

    mount { "/mnt/friedhof/":
      device => "UUID=5eee1578-60e1-4589-bddd-cd0bcc5935c7",
      fstype => ext3,
      ensure => mounted,
      options => "defaults",
      require => File["/mnt/friedhof"],
    }

    package { "mailutils":
      ensure => installed,
      require => Package["ssmtp"],
    }

  }
  
  class wake_fuckup {
    
    # Every server is supposed to start the Backup at 21:30
    package { "wakeonlan":
      ensure => present,
    }

    cron { start-fuckup:
      command => "wakeonlan 00:1b:21:31:40:d8",
      user => root,
      hour => 21,
      minute => 30,
      require => Package["wakeonlan"],
    }

  }
}
