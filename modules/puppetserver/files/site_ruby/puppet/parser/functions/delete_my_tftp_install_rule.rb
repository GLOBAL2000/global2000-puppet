require 'fileutils'

module Puppet::Parser::Functions
  newfunction(:delete_my_tftp_install_rule) do |args|
    mac = args[0].gsub(':','-')
    FileUtils.rm "/var/lib/tftpboot/pxelinux.cfg/01-#{mac}", :force => true
  end
end
