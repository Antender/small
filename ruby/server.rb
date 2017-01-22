include net/telnet.rb

class RATClient
  def initialize
    @server="0.0.0.0"
    @port=23
    attr_accessor :server, :port
  end
  
end
gets