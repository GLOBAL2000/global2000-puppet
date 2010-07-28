[libdefaults]
	default_realm = GLOBAL2000.AT
	kdc_timesync = 1
	ccache_type = 4
	forwardable = true
	proxiable = true

[realms]
	GLOBAL2000.AT = {
<% if out_of_house_use -%>
		kdc = kerberos.global2000.at
<% end -%>
		kdc = kerberos1
		kdc = kerberos2
		admin_server = kerberos1
	}

[appdefaults]
	always_aklog = true
	ignore_root = true
