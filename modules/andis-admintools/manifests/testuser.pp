class testuser {
  
  file {
    "/usr/local/home":
      ensure => directory,
      force => true,
  }
  
  user { "alice":
    ensure  => present,
    home => "/usr/local/home/alice",
    managehome => true,
    password => '$1$9u/vhWup$MUG77ERbYl2z0A999Rbn..',
    require => File["/usr/local/home"],
    shell => '/bin/bash',
  }
}
