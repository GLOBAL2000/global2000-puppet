<% network_prefix_reverse = broadcast.split('.').reject{|a| a=="0"}.reverse.join('.') -%>
<% bind_zones.each do |zone| -%>
zone "<%= zone -%>" {
     type master;
     file "/etc/bind/<%= zone -%>.zone";
};
<% end %>
<% bind_zones_reverse.each do |zone| -%>
zone "<%= network_prefix_reverse -%>.in-addr.arpa" {
        type master;
        file "/etc/bind/<%= zone -%>.reverse";
};
<% end %>