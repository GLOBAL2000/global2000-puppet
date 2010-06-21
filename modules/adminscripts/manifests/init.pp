class adminscripts {

   package { "RubyGEM depends":
    name => ["rubygems","ruby-dev","libsasl2-dev","libldap2-dev"],
    ensure => installed,
  }
  
  package { ["activeldap","ruby-ldap","trollop","rake"]:
    provider => gem,
    ensure => present,
    require => Package["RubyGEM depends"],
  }

  package { ["libsasl2-modules","libsasl2-modules-gssapi-mit"]:
    ensure => present,
  }

  file {
    "/usr/local/bin/g2ldap-user.rb":
      source => "puppet:///adminscripts/g2ldap/g2ldap-user.rb",
      owner => root, group => root, mode => 755;

    "/usr/local/bin/g2ldap-group.rb":
      source => "puppet:///adminscripts/g2ldap/g2ldap-group.rb",
      owner => root, group => root, mode => 755;

    "/usr/local/lib/site_ruby/g2ldap-config.rb":
      source => "puppet:///adminscripts/g2ldap/g2ldap-config.rb",
      owner => root, group => root, mode => 644;

    "/usr/local/lib/site_ruby/g2ldap-library.rb":
      source => "puppet:///adminscripts/g2ldap/g2ldap-library.rb",
      owner => root, group => root, mode => 644;

  }
  
}
