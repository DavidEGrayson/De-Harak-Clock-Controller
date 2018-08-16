# LedUdpController takes care of looking up the IP addresses of the LED systems
# and sending UDP packets to them with udpopc.  It caches IP addresses but does
# do any kind of caching of LED values (yet).
#
# Also, it has no error handling yet
module LedUdpController
  BroadcastIp = "192.168.174.255"
  NoHardware = ENV['NO_HARDWARE'] == 'Y'

  def self.set_by_ip(ip_address, hex_color)
    return if ip_address == :unknown
    cmd = "./udpopc #{ip_address} #{hex_color} 0 59 0 25 > /dev/null"
    if NoHardware
      puts cmd
      return
    end
    success = system(cmd)
    if !success
      $stderr.puts "Command failed: #{cmd}"
    end
  end

  def self.set_all(hex_color)
    set_by_ip(BroadcastIp, hex_color)
  end

  def self.all_black
    set_all('000000')
  end

  def self.get_ip(hostname)
    return "dummy.address.#{hostname}" if NoHardware
    @ip_cache ||= {}
    @ip_cache[hostname] ||= begin
      IPSocket.getaddress(hostname)
    rescue SocketError
      $stderr.puts "Failed to get IP for #{hostname}"
      :unknown
    end
  end

  def self.set_by_hostname(hostname, hex_color)
    set_by_ip(get_ip(hostname), hex_color)
  end

  # num should be between 1 and 12
  def self.set_top(num, hex_color)
    set_by_hostname("h%02d" % num, hex_color)
  end

  # num should be between 0 and 59
  def self.set_bottom(num, hex_color)
    set_by_hostname("m%02d" % num, hex_color)
  end
end
