class fileserver {
# NFS and OpenAFS here

	package {
          "nfs-kernel-server":
	    ensure => present,
	}

	service {
          "nfs-kernel-server":
	    ensure => running,
	    enable => true,
	    hasrestart => true,
	    hasstatus => true,
	    require => Package["nfs-kernel-server"],
	    subscribe => File["/etc/exports"],
	}

	file {	
          "/etc/exports":
	    mode => 644, owner => root, group => root,
	    require => Package["nfs-kernel-server"],
            source => "puppet:///fileserver/etc-exports",
	}

        # Packages provided, but you need to create the Database etc yourself (afs-newcell, afs-rootvol)
        package {
          ["openafs-dbserver","openafs-fileserver","openafs-krb5"]:
            ensure => present,
        }

        file {
          "/root/afs.keytab":
            ensure => present,
            source => "puppet:///fileserver/afs.keytab",
        }

        file {
          "/root/mrafsadminhimself.keytab":
            ensure => present,
            source => "puppet:///fileserver/mrafsadminhimself.keytab",
        }            
        
        file {
          "/var/lib/openafs/local/NetInfo":
            content => "$ipaddress\nf $afsserver_global_ip\n",
        }

        file {
          "/etc/openafs/CellServDB":
            content => ">global2000.at\t#GLOBAL2000 - FOE Europe\n$ipaddress\t#$hostname\n",
        }

        file {
         "/etc/openafs/ThisCell":
            content => "global2000.at\n",
        } 

        file {
          "/etc/openafs/server/CellServDB":
            content => ">global2000.at\t#GLOBAL2000 - FOE Europe\n$ipaddress\t#$hostname\n",
        }

        file {
         "/etc/openafs/server/ThisCell":
            content => "global2000.at\n",
        }
        
        package {
          "module-assistant":
            ensure => present,
        }
}
