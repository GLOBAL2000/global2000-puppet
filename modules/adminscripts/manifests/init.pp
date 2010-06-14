class adminscripts {

   package { "RubyGEM depends":
    name => ["rubygems","ruby-dev","libsasl2-dev","libldap2-dev"],
    ensure => installed,
  }
  
  package { ["activeldap","ruby-ldap","trollop"]:
    provider => gem,
    ensure => present,
    require => Package["RubyGEM depends"],
  }

  package { ["libsasl2-modules","libsasl2-modules-gssapi-mit"]:
    ensure => present,
  }

}
