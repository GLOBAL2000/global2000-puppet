class desktop::googleearth {
  
   package {
     "google_earth":
       ensure => present,
       source => "/var/tmp/googleearth.deb",
       require => Get_by_rsync["googleearth.deb"],
       provider => 'dpkg';
   }

  get_by_rsync{ "googleearth.deb": }
}
