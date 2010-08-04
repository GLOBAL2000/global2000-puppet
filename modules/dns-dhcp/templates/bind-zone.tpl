<% network_prefix = broadcast.split('.').reject{|a| a=="0"}.join('.') -%>
<% require 'csv' -%>
<% CSV.open( csv_path+'/'+zone_name+'.csv' , 'r',';') do |row| -%>
<% 
if row[0].to_s.slice(0,1) == '#'
   next
elsif row[2]
   a_record = row[2].split(',').first
   c_names = row[2].split(',')[1..row[2].length] 
else
   a_record = []
   c_names = []
end
-%>
<%= a_record %>	IN	A	<%= network_prefix %>.<%= row[1] %>
<% c_names.each do |cn| -%>
<%= cn %>	IN CNAME	<%= a_record %>
<% end -%>
<% end -%>
