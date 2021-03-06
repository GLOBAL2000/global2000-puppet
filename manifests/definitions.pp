define gconf($type="string", $list_type="string", $preference="defaults", $prefix="xml:readwrite:", $location="/etc/gconf/gconf.xml.", $ensure="present") {
  case $ensure {
    absent: {
      exec{
        "unset $name":
          command => "/usr/bin/gconftool-2 --direct --config-source ${prefix}${location}${preference} --unset $name",
          logoutput => on_failure,
          unless => "/bin/sh -c \"test -z $(/usr/bin/gconftool-2 --direct --config-source ${prefix}${location}$preference --get $name)\"",
      }
    }
    
    default: {
      $gconftest = "test \"$(/usr/bin/gconftool-2 --direct --config-source ${prefix}${location}${preference} --get $name)\" = \"$ensure\""
      exec{
        "set $name to $ensure with preference $preference":
          command => "/usr/bin/gconftool-2 --direct --config-source ${prefix}${location}${preference} --type=$type --list-type $list_type --set $name \"$ensure\"",
          unless => "/bin/sh -c \"${gconftest}\"",
          logoutput => on_failure,
      }
    }
  }
}

define get_by_rsync( $destination="/var/tmp/") {
  exec { "rsync_$name":
    command => "rsync -qrL ${rsyncserver}::rsync/${name} ${destination}",
  }
}

define maildirmake( $home , $owner="root", $group="root", $mode="700") {
  exec { "make maildir $name":
    command => "maildirmake.dovecot $home/maildir/.$name && chown -R $owner:$group $home/maildir/.$name && chmod -R $mode $home/maildir/.$name",
    creates => "$home/maildir/.$name",
  }
}

define bind_zone() {
  $zone_name = $name
  file { # Default DNS
    "/etc/bind/${zone_name}.zone":
      content => template("dns-dhcp/bind-zone-header.tpl","dns-dhcp/bind-zone.tpl"),
  }
}

define bind_zone_reverse() {
  $zone_name = $name
  file {
    "/etc/bind/${zone_name}.reverse":
      content => template("dns-dhcp/bind-zone-header.tpl","dns-dhcp/bind-zone-reverse.tpl"),
  }
}

define autofs_master() { 

  file {
    "/etc/default/autofs":
      tag => "debootstrap",
      source => "puppet:///autofs/etc-default-autofs",
  }

  package {
    "autofs":
      name => $operatingsystem ? {
        default	=> "autofs5",
      },
      ensure => present,
  }
  
  service {
    "autofs":
      ensure => running,
      enable => true,
      pattern => "automount",
      require => Package[autofs],
      subscribe => File["/etc/auto.master"],
  }

  file { "/etc/auto.master":
    owner => root,
    group => root,
    mode => 644,
    tag => "debootstrap",
    content => template("autofs/auto.master.erb"),
    notify => Service[autofs],
  }      

}

define autofs_mount( $dynamic=false ) { 

  file { "/etc/auto.$name":
    ensure => file,
    tag => "debootstrap",
    owner => root,
    group => root,
    mode => 644,
    notify => Service[autofs],
    content => template("autofs/auto.mount.erb"),
  }
  
}

define apache::module ( $ensure = 'present', $require_package = 'apache' ) {
  $mods = "/etc/apache2/mods"
  
  case $ensure {
    'present' : {
      exec { "/usr/sbin/a2enmod $name":
        unless => "/bin/sh -c '[ -L ${mods}-enabled/${name}.load ] && [ ${mods}-enabled/${name}.load -ef ${mods}-available/${name}.load ]'",
        notify => Service["apache"],
        require => Package["apache"],
      }
    }
    'absent': {
      exec { "/usr/sbin/a2dismod $name":
        onlyif => "/bin/sh -c '[ -L ${mods}-enabled/${name}.load ] && [ ${mods}-enabled/${name}.load -ef ${mods}-available/${name}.load ]'",
        notify => Service["apache"],
        require => Package["apache"],
      }
    }
  }
}

