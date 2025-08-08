require "optparse"
require "listen"

class CadWatcher
  attr_reader :bin_paths, :filetype_globs, :watch_globs, :render_cmd_template, :debug_mode, :bin_name

  def initialize(
    bin_paths: [],         # Now always an Array of Strings
    bin_glob: nil,
    bin_name: nil,         # Optional binary name to search on PATH first
    filetype_globs:,
    watch_globs:,
    render_cmd_template:,
    debug_mode: false
  )
    @debug_mode = debug_mode
    @bin_name = bin_name
    @bin_paths = bin_paths
    @bin_path = find_bin(bin_name, bin_paths, bin_glob)
    @filetype_globs = Array(filetype_globs)
    @watch_globs = Array(watch_globs)
    @render_cmd_template = render_cmd_template
  end

  def self.main(bin_config = {}, argv = ARGV)
    # default watch_globs to "*"
    defaults = { watch_globs: ["*"] }
    cli_config = config_from_argv(argv)
    # After parsing, argv contains only positional args (globs)
    watch_globs = argv.empty? ? nil : argv.dup
    merged = bin_config.merge(cli_config)
    merged[:watch_globs] = watch_globs if watch_globs
    merged = defaults.merge(merged)
    watcher = new(**merged)
    watcher.start
  end

  def start
    first_run
    listener = Listen.to(".") do |added, removed, modified|
      debug "modified: #{modified}" unless modified.empty?
      debug "added: #{added}" unless added.empty?
      debug "removed: #{removed}" unless removed.empty?
      files_to_run = (added + modified).select { |f| match_any_glob?(f, watch_globs) }
      run(files_to_run)
    end
    listener.only(*watch_globs.map { |g| glob_to_regexp(g) })
    listener.start
    sleep
  end

  def first_run
    files = filetype_globs.flat_map { |g| Dir.glob(g) }.uniq
    files.select! { |f| match_any_glob?(f, watch_globs) }
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
      cmd = render_cmd_template.call(@bin_path, file, stl_file)
      debug cmd
      puts "Running: #{cmd}"
      value = `#{cmd}`
      result = $CHILD_STATUS.exitstatus
      puts value
      raise "Command failed: #{cmd}" unless result.zero?
      puts "--" unless idx == files.size - 1
    end
    puts "--------"
  end

  private

  def match_any_glob?(file, globs)
    globs.any? { |glob| File.fnmatch(glob, file) }
  end

  def find_bin(bin_name, bin_paths, bin_glob)
    # 1. Check bin_name on PATH
    if bin_name
      path = `which #{bin_name}`.strip
      if !path.empty? && File.exist?(path) && File.executable?(path)
        puts "Using binary from PATH: #{path}"
        return path
      end
    end

    # 2. Check bin_paths
    unless bin_paths.is_a?(Array)
      raise ArgumentError, "bin_paths must be an array of paths"
    end

    bin_paths.each do |bin_path|
      expanded = File.expand_path(bin_path)
      return expanded if File.exist?(expanded) && File.executable?(expanded)
    end

    # 3. Check bin_glob
    if bin_glob
      found = Array(bin_glob).flat_map { |g| Dir.glob(g) }.find { |f| File.executable?(f) }
      if found
        puts "Using binary: #{found}"
        return found
      end
    end

    raise "Binary not found. Searched bin_name: #{bin_name.inspect}, paths: #{bin_paths.inspect}, globs: #{bin_glob.inspect}"
  end

  def debug(msg)
    puts "[DEBUG] #{msg}" if debug_mode
  end

  def glob_to_regexp(glob)
    Regexp.new('\A' + glob.gsub('.', '\.').gsub('*', '.*') + '\z')
  end

  class << self
    private

    # Returns a hash of options from CLI args
    def config_from_argv(argv)
      config = {}
      OptionParser.new do |opts|
        opts.banner = <<~BANNER
          Usage: #{File.basename($0)} [options] [watch_glob1 watch_glob2 ...]
          Watches files matching the given globs (default: "*") and runs the render command when they change.

          Options:
        BANNER

        opts.on("-b", "--bin-name NAME", "Set the binary name") { |v| config[:bin_name] = v }
        opts.on("-d", "--debug", "Enable debug mode") { config[:debug_mode] = true }
        opts.on("-v", "--version", "Show version") do
          require_relative "./version"
          puts ImplicitcadWatcher::VERSION
          exit
        end
        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit
        end
      end.parse!(argv)
      config # Always a hash!
    end
  end
end
