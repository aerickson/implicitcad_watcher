require "listen"

class CadWatcher
  attr_reader :bin_path, :file_globs, :file_regex, :render_cmd_template, :debug_mode

  def initialize(
    bin_path: nil,
    bin_glob: nil,
    file_globs:,
    file_regex:,
    render_cmd_template:,
    debug_mode: false
  )
    @debug_mode = debug_mode
    @bin_path = find_bin(bin_path, bin_glob)
    @file_globs = Array(file_globs)
    @file_regex = file_regex
    @render_cmd_template = render_cmd_template
  end

  def self.main(argv = [])
    # This method should be called from the bin script.
    watcher = new(*self.config_from_argv(argv))
    watcher.start
  end

  def start
    first_run
    listener = Listen.to(".") do |added, removed, modified|
      debug "modified: #{modified}" unless modified.empty?
      debug "added: #{added}" unless added.empty?
      debug "removed: #{removed}" unless removed.empty?
      files_to_run = (added + modified).select { |f| f.match?(file_regex) }
      run(files_to_run)
    end
    listener.only(file_regex)
    listener.start
    sleep
  end

  def first_run
    files = file_globs.flat_map { |g| Dir.glob(g) }.uniq
    files.select! { |f| f.match?(file_regex) }
    run(files) unless files.empty?
  end

  def get_result_file(source_file)
    dest_dir = File.dirname(source_file)
    base_name = File.basename(source_file, File.extname(source_file))
    File.join(dest_dir, "#{base_name}.stl")
  end

  def run(files)
    files.each_with_index do |file, idx|
      stl_file = get_result_file(file)
      cmd = render_cmd_template.call(bin_path, file, stl_file)
      debug cmd
      value = `#{cmd}`
      result = $CHILD_STATUS.exitstatus
      puts value
      raise "Command failed: #{cmd}" unless result.zero?
      puts "--" unless idx == files.size - 1
    end
    puts "--------"
  end

  private

  def find_bin(bin_path, bin_glob)
    if bin_path && File.exist?(File.expand_path(bin_path))
      File.expand_path(bin_path)
    elsif bin_glob
      found = Array(bin_glob).flat_map { |g| Dir.glob(g) }.find { |f| File.executable?(f) }
      if found
        puts "Using binary: #{found}"
        found
      else
        raise "CAD binary not found. Searched: #{bin_glob.inspect}"
      end
    else
      raise "No binary path or glob provided."
    end
  end

  def debug(msg)
    puts "[DEBUG] #{msg}" if debug_mode
  end

  # Optionally, parse CLI args here
  def self.config_from_argv(argv)
    # For now, just return an empty hash; bin scripts should pass config directly.
    []
  end
end