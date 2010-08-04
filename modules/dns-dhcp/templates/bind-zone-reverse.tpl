<% require 'csv' -%>
<% CSV.open( csv_path+'/'+zone_name+'.csv' , 'r',';') do |row| -%>
<% 
if row[0].to_s.slice(0,1) == '#'
   next
elsif row[2]
   a_record = row[2].split(',').first 
end
-%>
<%= row[1].split('.').reverse.join('.') %>	IN	PTR	<%= a_record %>.<%= zone_name %>.
<% end -%>
