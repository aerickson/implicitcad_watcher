#!/usr/bin/env ruby

require 'listen'

ESCAD_FILE = '*.escad'
IMPLICITCAD_BIN = '~/.cabal/bin/extopenscad'

# TODO: open a quickview window (`qlmanage -p FILE`) or get info window
# - qlmanage seems to hang/beach ball...
# - write little os x app for it?
#   - https://github.com/Daij-Djan/QuicklookAdditionalViews

def run_command()
  puts "in run_command"
  cmd = "#{IMPLICITCAD_BIN} -f stl -o output.stl #{ESCAD_FILE}"
  puts cmd
  # TODO: do this
  value = `#{cmd}`
  result = $?.exitstatus
  # puts result
  puts value
  if result == 0 then
    # puts 'ok'
  else
    puts 'error'
    raise
  end
end

run_command()
listener = Listen.to('.') do |added,removed,modified|
  puts "modified absolute path: #{modified}"
  puts "added absolute path: #{added}"
  puts "removed absolute path: #{removed}"
  puts "***"
  run_command()
  # if modified.include?('escad') then
  #   puts "escad file"
  # end
end
listener.start # not blocking
listener.only /\.escad$/ # overwrite all existing only patterns.
sleep
