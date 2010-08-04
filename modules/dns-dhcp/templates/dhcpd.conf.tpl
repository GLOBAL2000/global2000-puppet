<% require 'resolv' -%>
<% 
nameserver_ips=[]
nameservers.each do |n| 
  nameserver_ips.push(Resolv.getaddress(n))
end
-%>
ddns-update-style none;

log-facility local7;

subnet <%= broadcast -%> netmask <%= netmask -%> {
       option domain-name "<%= dns_suffix -%>";
       option domain-name-servers <%= nameserver_ips.join(',') -%>;
       option routers <%= Resolv.getaddress(firewall) -%>;
       option subnet-mask <%= netmask -%>;
       option ntp-servers <%= Resolv.getaddress(ntpserver) -%>;
       get-lease-hostnames     true;
       default-lease-time 57600;
       max-lease-time 288000;
       range 192.168.40.1 192.168.40.200;
}

group {
      include "<%= dhcp_path -%>/fixed-address-hosts.conf";
      next-server <%= Resolv.getaddress(puppetserver) -%>;
      filename "pxelinux.0";
}
