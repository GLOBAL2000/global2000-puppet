#!/usr/bin/ruby
require 'fileutils'

ethersfile = '/etc/ethers'
pxepath = '/var/lib/tftpboot/pxelinux.cfg'
templatefile = 'install-karmic/default'
puppetuser = "puppet"
puppetgroup = "puppet"

ethers = {}
macadressen = []

if File.exists?(ethersfile)
  file = File.open(ethersfile)
  
  file.each_line do |line|
    mac, hostname = line.split
    ethers[hostname] = mac
  end

file.close
end



ARGV.each do |arg|
  gefundenemacadresse = arg.match(/(01-)?([0-9a-f]{2}[:-]){5,5}[0-9a-f]{2}/i)
  if gefundenemacadresse
    macadressen << gefundenemacadresse.to_s.downcase
  else 
    hostname =  arg.gsub(/\..*$/,"")
    macadressen << ethers[hostname] unless ethers[hostname].nil?
  end
end

macadressen.each do |mac|
  mac.gsub!(":","-")
  mac.downcase!
  if mac.length == 6*2+5
    mac = '01-' + mac
  end
  FileUtils.cp "#{pxepath}/#{templatefile}", "#{pxepath}/#{mac}", :verbose => true
  FileUtils.chown puppetuser, puppetgroup, "#{pxepath}/#{mac}"
end
