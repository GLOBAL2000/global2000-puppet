<% network_prefix = network.split('.').reject{|a| a=="0"}.join('.') -%>
<% require 'csv' -%>
<% CSV.open( csv_path+'/'+g2_net_table+'.csv' , 'r',';') do |row| -%>
<% 
if row[0].to_s.slice(0,1) == '#'
   next
end
-%>
host <%= row[2].split(',').first -%> {
     hardware ethernet <%= row[0] -%>;
     fixed-address <%= network_prefix -%>.<%= row[1] -%>;
}
<% end -%>