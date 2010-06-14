require 'fileutils'

module Puppet::Parser::Functions
  newfunction(:delete_my_signed_certficate) do |args|
    hostname = args[0]
    FileUtils.rm Dir.glob("/var/lib/puppet/ssl/ca/signed/#{hostname}.*"), :force => true
  end
end
