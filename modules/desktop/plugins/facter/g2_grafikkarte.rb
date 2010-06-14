# g2_grafikkarte.rb TODO:refactor

if FileTest.exists?("/usr/bin/lspci")
  output = %x{lspci}


  Facter.add("g2_grafikkarte") do
    setcode do
      vga = ""
      ausgabe = ""
      output.each { |s|
        vga = $1 if  s =~ /VGA compatible controller: (.*)/
      }
      %w[intel nvidia radeon].each do |graka|
        ausgabe = graka if vga =~ Regexp.new(graka, true)
      end
      ausgabe
    end
  end
end
