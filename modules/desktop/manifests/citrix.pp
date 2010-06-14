class citrix {

  package {
    "icaclient":
      ensure => present,
      source => "/var/tmp/icaclient.deb",
      require => [ Get_by_rsync["icaclient.deb"], File["/usr/lib/libXm.so.4"]],
      provider => 'dpkg',
  }
  
  get_by_rsync { "icaclient.deb": }
  
  package {
    "libmotif3":
      ensure => present,
  }
  
  file {
    "/usr/lib/libXm.so.4":
      ensure => "/usr/lib/libXm.so.3",
      require => Package[libmotif3],
  }

  file {
    "/usr/lib/ICAClient":
      ensure => directory,
      recurse => true,
      source => "puppet:///desktop/citrix/ICAClient"
  }

  file {
    "/usr/local/share/applications/wfcmgr.desktop":
    ensure => "/usr/lib/ICAClient/desktop/wfcmgr.desktop",
  }

  file {
    "/usr/lib/mime/packages/icaclient":
      content => "application/x-ica; /usr/lib/ICAClient/wfica.sh %s; x-mozilla-flags=plugin:Citrix ICA",
      notify => Exec[update-mime]
      }

  exec {
    "update-mime":
      path => '/usr/sbin',
      refreshonly => true,
  }
      
}
