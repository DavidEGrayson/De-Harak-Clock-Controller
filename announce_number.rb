#!/usr/bin/env ruby

require_relative 'led_udp_controller'

if ARGV.size < 1
  $stderr.puts "Usage: announce_number.rb NUM"
  exit 1
end

number = ARGV[0].to_i
sinebow_colors = File.foreach('sinebowcycle.txt').map(&:chomp)

LedUdpController.all_black
while true
  sinebow_colors.each do |color|
    LedUdpController.set_bottom(number, color)
    sleep 0.016
  end
end
