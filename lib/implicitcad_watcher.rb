#!/usr/bin/env ruby

require 'listen'

require_relative 'openscad_watcher'

# here now
class ImplicitCadWatcher
  DEBUG_MODE = false
  ESCAD_FILE_ENDING = '.escad'.freeze
  ESCAD_FILE_GLOB = ('*' + ESCAD_FILE_ENDING).freeze
  ESCAD_REGEX = /#{Regexp.escape(ESCAD_FILE_ENDING)}$/
  IMPLICITCAD_BIN = '~/.cabal/bin/extopenscad'.freeze

  attr_accessor :debug_mode, :ESCAD_FILE_GLOB, :ESCAD_FILE_ENDING, :ESCAD_REGEX,
                :IMPLICITCAD_BIN, :RENDER_CMD

  # TODO: open a quickview window (`qlmanage -p FILE`) or get info window
  # - qlmanage seems to hang/beach ball...
  # - write little os x app for it?
  #   - https://github.com/Daij-Djan/QuicklookAdditionalViews

  def self.first_run
    # TODO: if there is an escad file in the directory, call run
    files = Dir.glob(ESCAD_FILE_GLOB)
    return unless files
    run(files)
  end

  def self.get_result_file(source_file)
    dest_dir = File.dirname(source_file)
    base_name = File.basename(source_file, ESCAD_FILE_ENDING)
    File.join(dest_dir, "#{base_name}.stl")
  end

  def self.run(files)
    files.each do |file|
      stl_file = get_result_file(file)
      render_cmd = "#{IMPLICITCAD_BIN} -f stl -o \"#{stl_file}\" \"#{file}\""
      puts render_cmd if DEBUG_MODE
      value = `#{render_cmd}`
      result = $CHILD_STATUS.exitstatus
      puts value
      raise Exception('Command failed.') unless result.zero?
      puts '--' unless file.equal?(files.last)
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
      files_to_run = added + modified
      run(files_to_run)
    end
    listener.start # not blocking
    listener.only(ESCAD_REGEX) # overwrite all existing only patterns.
    sleep
  end
end
