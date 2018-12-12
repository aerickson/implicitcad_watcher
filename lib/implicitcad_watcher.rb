#!/usr/bin/env ruby

require 'listen'

# here now
class ImplicitCadWatcher
  DEBUG_MODE = false
  ESCAD_FILE = '*.escad'.freeze
  IMPLICITCAD_BIN = '~/.cabal/bin/extopenscad'.freeze
  RENDER_CMD = "#{IMPLICITCAD_BIN} -f stl -o output.stl #{ESCAD_FILE}".freeze

  attr_accessor :debug_mode, :ESCAD_FILE, :IMPLICITCAD_BIN, :RENDER_CMD

  # TODO: open a quickview window (`qlmanage -p FILE`) or get info window
  # - qlmanage seems to hang/beach ball...
  # - write little os x app for it?
  #   - https://github.com/Daij-Djan/QuicklookAdditionalViews

  def self.first_run
    # TODO: if there is an escad file in the directory, call run
    return unless Dir.glob(ESCAD_FILE)
    run
  end

  def self.run
    puts RENDER_CMD if DEBUG_MODE
    # TODO: do this
    value = `#{RENDER_CMD}`
    result = $CHILD_STATUS.exitstatus
    # puts result
    puts value
    if result.zero?
      # puts 'ok'
    else
      puts 'error'
      raise
    end
    puts '--------'
  end

  def self.main(_argv)
    # puts "#{$PROGRAM_NAME}: watching..."
    first_run
    listener = Listen.to('.') do |added, removed, modified|
      puts "modified absolute path: #{modified}" if DEBUG_MODE
      puts "added absolute path: #{added}" if DEBUG_MODE
      puts "removed absolute path: #{removed}" if DEBUG_MODE
      run
    end
    listener.start # not blocking
    listener.only(/\.escad$/) # overwrite all existing only patterns.
    sleep
  end
end
