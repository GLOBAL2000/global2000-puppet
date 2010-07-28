if FileTest.exists?("/usr/bin/lspci")
  output = %x{lspci}


  Facter.add("g2_wlan") do
    setcode do
      wlan = ""
      ausgabe = ""
      output.each { |s|
        wlan = $1 if  s =~ /Network controller: (.*)/
      }
      %w[bcm4312].each do |controller|
        ausgabe = controller if wlan =~ Regexp.new(controller, true)
      end
      ausgabe
    end
  end
end
