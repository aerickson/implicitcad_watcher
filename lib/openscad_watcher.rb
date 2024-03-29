#!/usr/bin/env ruby

require "listen"

class OpenscadWatcher
  DEBUG_MODE = true
  # TODO: refactor names of these vars
  # work on .scad and .escad
  ESCAD_FILE_GLOB = [("*.scad"),
                     "*.escad"].freeze
  ESCAD_REGEX = /\.[e]*scad$/
  # TODO: allow cnofiguration or better detection for non OS X
  IMPLICITCAD_BIN = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD".freeze

  # rubocop:disable all
  attr_accessor :debug_mode, :ESCAD_FILE_GLOB, :ESCAD_FILE_ENDING, :ESCAD_REGEX,
                :IMPLICITCAD_BIN, :RENDER_CMD
  # rubocop:enable all


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
    base_name_with_suffix = File.basename(source_file)
    base_name = base_name_with_suffix.split(".")[0]
    File.join(dest_dir, "#{base_name}.stl")
  end

  def self.run(files)
    files.each do |file|
      stl_file = get_result_file(file)
      render_cmd = "#{IMPLICITCAD_BIN} -o \"#{stl_file}\" \"#{file}\""
      puts render_cmd if DEBUG_MODE
      value = `#{render_cmd}`
      result = $CHILD_STATUS.exitstatus
      puts value
      raise "Command failed." unless result.zero?
      puts "--" unless file.equal?(files.last)
    end
    puts "--------"
  end

  def self.main(_argv)
    # puts "#{$PROGRAM_NAME}: watching..."
    first_run
    listener = Listen.to(".") do |added, removed, modified|
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
