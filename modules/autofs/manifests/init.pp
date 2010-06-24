class autofs {

  class clients {
    package {
      "autofs":
        name => $operatingsystem ? {
          default   => "autofs5",
        },
        ensure => present,
    }

    service {
      "autofs":
        ensure => running,
        enable => true,
        pattern => "automount",
        require => Package[autofs],
        subscribe => [ File["/etc/auto.master"], File["/etc/auto.home"], File["/etc/auto.nfs"] ],
    }

    file {
      "/etc/auto.master":
        tag => "debootstrap",
        mode => 644, owner => root, group => root,
        require => Package[autofs],
        content => "/home /etc/auto.home\n/mnt /etc/auto.nfs\n",
    }
    file {
      "/etc/auto.home":
        tag => "debootstrap",
        mode => 644, owner => root, group => root,
        content => "*       $nfsserver:/home/&\n",
    }

    file {
      "/etc/auto.nfs":
        tag => "debootstrap",
        mode => 644, owner => root, group => root,
        content => template("autofs/etc-auto.nfs.erb"),
    }

    file {
      "/etc/default/autofs":
        tag => "debootstrap",
        source => "puppet:///autofs/etc-default-autofs",
    }
  }
  
  class sustain {
    $mounts = [ "sustain" ]
    autofs_master { $mounts: }
    autofs_mount { $mounts: }   
  }
 
}
