#!/usr/bin/env ruby

require 'listen'

# here now
class ImplicitCadWatcher
  DEBUG_MODE = false
  ESCAD_FILE = '*.escad'.freeze
  IMPLICITCAD_BIN = '~/.cabal/bin/extopenscad'.freeze

  attr_accessor :debug_mode, :ESCAD_FILE, :IMPLICITCAD_BIN, :RENDER_CMD

  # TODO: open a quickview window (`qlmanage -p FILE`) or get info window
  # - qlmanage seems to hang/beach ball...
  # - write little os x app for it?
  #   - https://github.com/Daij-Djan/QuicklookAdditionalViews

  def self.first_run
    # TODO: if there is an escad file in the directory, call run
    files = Dir.glob(ESCAD_FILE)
    return unless files
    run(files)
  end

  def get_result_file(source_file)
    dest_dir = File.dirname(source_file)
    base_name = File.basename(source_file, '.escad')
    File.join(dest_dir, "#{base_name}.stl")
  end

  def self.run(files)
    files.each do |file|
      stl_file = get_result_file(file)
      render_cmd = "#{IMPLICITCAD_BIN} -f stl -o #{stl_file} #{file}"
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
      puts "BLJALF: #{added} / #{removed} / #{modified}"
      files_to_run = added + modified
      run(files_to_run)
    end
    listener.start # not blocking
    listener.only(/\.escad$/) # overwrite all existing only patterns.
    sleep
  end
end
