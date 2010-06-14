class clientauth {
  class ldap {
    package {
      nscd:
        ensure => present,
    }

    file { "/etc/nscd.conf":
      require => Package["nscd"],
      source => "puppet:///clientauth/etc-nscd.conf",
    }

    file {
      "/etc/libnss-ldap.conf":
        path => $operatingsystem ? {
          Ubuntu => "/etc/ldap.conf",
          Debian => "/etc/libnss-ldap.conf",
        },
        source => "puppet:///clientauth/etc-ldap.conf",
    }
    package {
      libnss-ldap:
        ensure => present,
    }
    
    file {
      "/etc/nsswitch.conf":
        require => Package["libnss-ldap"],
        source => "puppet:///clientauth/etc-nsswitch-conf",
    }

  }

  class pam {
    case $operatingsystemrelease {
      /(5.0.*)/: {
        file {
          "/etc/pam.d/common-account":
            source => "puppet:///clientauth/etc-pam.d-common-account";

          "/etc/pam.d/common-auth":
            source => "puppet:///clientauth/etc-pam.d-common-auth";

          "/etc/pam.d/common-password":
            source => "puppet:///clientauth/etc-pam.d-common-password";

          "/etc/pam.d/common-session":
            source => "puppet:///clientauth/etc-pam.d-common-session";
        }
      }
    }

  }

}
