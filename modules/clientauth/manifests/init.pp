class clientauth {
  class ldap-common {
    package {
      nscd:
        ensure => present,
    }

    file { "/etc/nscd.conf":
      require => Package["nscd"],
      source => "puppet:///clientauth/etc-nscd.conf",
    }

    file {
      ["/etc/libnss-ldap.conf", "/etc/ldap.conf", "/etc/ldap/ldap.conf"]:
       content => inline_template('
uri <%= ldapservers.map{|l| "ldap://#{l}/"}.join " " %>
base <%= ldap_rootdn %>
nss_initgroups_ignoreusers +,avahi,avahi-autoipd,backup,bin,couchdb,daemon,fuse,games,gdm,gnats,haldaemon,hplip,irc,kernoops,kvm,libuuid,list,lp,mail,man,messagebus,nagios,news,ntp,nvram,proxy,pulse,puppet,rdma,root,rtkit,saned,scanner,speech-dispatcher,sshd,statd,sync,sys,syslog,tss,usbmux,uucp,www-data
')
    }
    
    file {
      "/etc/nsswitch.conf":
        require => Package["ldap-for-nss"],
        source => "puppet:///clientauth/etc-nsswitch-conf",
    }

  }

  class ldap inherits clientauth::ldap-common {
    package {
      "ldap-for-nss":
        name => "libnss-ldap",
        ensure => present,
    }
  }
  
  class libnss-ldapd inherits clientauth::ldap-common {
    package {
      "ldap-for-nss":
        name => "libnss-ldapd",
        ensure => present,
    }

    file {
      "/etc/nslcd.conf":
        content => inline_template("
uid nslcd
gid nslcd
<% ldapservers.each do |l| -%>
uri ldap://<%= l %>/
<% end -%>
base <%= ldap_rootdn %>
")
    }
    notice "class libnss-ldapd"
  }
  

  class pam {
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
