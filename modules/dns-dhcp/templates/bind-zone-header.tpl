<% network_prefix = broadcast.split('.').reject{|a| a=="0"}.join('.') -%>
$TTL    604800
@     IN      SOA     <%= fqdn -%>. <%= contactemail.sub('@','.') -%>. (
      <%= Time.new.strftime("%Y%m%d") -%>	; Serial
      28800		    ; Refresh
      7200		    ; Retry
      864000		    ; Expire
      86400		    ; Min TTL
      )
<% nameservers.each do |ns| -%>
	IN	NS	<%= ns -%>.
<% end -%>
<%
# CNames are not allowed to be MX records. Uncomment this then mailserver is ported to a VM
#	IN	MX	10	<%= mailserver -%>. 
-%>

