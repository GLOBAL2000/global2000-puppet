class bla {

	package { bla:
		name => $operatingsystem ? {
			default	=> "bla",
			},
		ensure => present,
	}

	service { bla:
		name => $operatingsystem ? {
                        default => "bla",
                        },
		ensure => running,
		enable => true,
		hasrestart => true,
		hasstatus => true,
		require => Package["bla"],
		subscribe => File["bla"],
	}

	file {	
             	"bla":
		mode => 644, owner => root, group => root,
		require => Package[bla],
		path => $operatingsystem ?{
                       	default => "bla",
                        },
                source => "puppet:///bla/bla",
	}

}
