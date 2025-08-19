require "spec_helper"

describe CadWatcher do
  let(:dummy_bin) { "/bin/echo" }
  let(:filetype_globs) { ["test/*.escad"] }
  let(:watch_globs) { ["test/*.escad"] }
  let(:render_cmd_template) { ->(bin, src, dest) { "#{bin} #{src} #{dest}" } }

  describe "#initialize" do
    it "sets attributes correctly" do
      watcher = CadWatcher.new(
        bin_paths: [dummy_bin],
        filetype_globs: filetype_globs,
        watch_globs: watch_globs,
        render_cmd_template: render_cmd_template,
        debug_mode: true,
      )
      expect(watcher.filetype_globs).to eq(filetype_globs)
      expect(watcher.watch_globs).to eq(watch_globs)
      expect(watcher.render_cmd_template).to eq(render_cmd_template)
      expect(watcher.debug_mode).to eq(true)
    end
  end

  describe "#get_result_file" do
    it "returns .stl file path for a given source file" do
      watcher = CadWatcher.new(
        bin_paths: [dummy_bin],
        filetype_globs: filetype_globs,
        watch_globs: watch_globs,
        render_cmd_template: render_cmd_template,
      )
      expect(watcher.get_result_file("foo/bar/test.escad")).to eq("foo/bar/test.stl")
    end
  end

  describe ".config_from_argv" do
    it "parses --bin-name and --debug" do
      config = CadWatcher.send(:config_from_argv, ["--bin-name", "mybin", "--debug"])
      expect(config[:bin_name]).to eq("mybin")
      expect(config[:debug_mode]).to eq(true)
    end
  end

  describe "#run" do
    it "runs the render command for each file" do
      watcher = CadWatcher.new(
        bin_paths: [dummy_bin],
        filetype_globs: filetype_globs,
        watch_globs: watch_globs,
        render_cmd_template: render_cmd_template,
      )
      files = ["test/test.escad"]
      expect { watcher.run(files) }.to output(/Running: \/bin\/echo test\/test.escad test\/test.stl/).to_stdout
    end
  end

  describe "#find_bin" do
    it "finds a binary by bin_name on PATH" do
      watcher = CadWatcher.allocate
      path = watcher.send(:find_bin, "echo", [], nil)
      expect(path).to end_with("/echo")
    end

    it "raises if binary not found" do
      watcher = CadWatcher.allocate
      expect {
        watcher.send(:find_bin, "nonexistent_binary", [], nil)
      }.to raise_error(/Binary not found/)
    end
  end

  describe "#first_run" do
    it "calls run with files matching filetype_globs and watch_globs" do
      watcher = CadWatcher.new(
        bin_paths: [dummy_bin],
        filetype_globs: ["test/*.escad"],
        watch_globs: ["test/*.escad"],
        render_cmd_template: render_cmd_template,
      )
      allow(Dir).to receive(:glob).with("test/*.escad").and_return(["test/test.escad", "test/haha.escad", "test/ignore.txt"])
      expect(watcher).to receive(:run).with(["test/test.escad", "test/haha.escad"])
      watcher.first_run
    end
  end

  describe "#glob_to_regexp" do
    let(:watcher) {
      CadWatcher.new(
        bin_paths: [dummy_bin],
        filetype_globs: filetype_globs,
        watch_globs: watch_globs,
        render_cmd_template: render_cmd_template,
      )
    }

    it "converts '*' to match any characters" do
      re = watcher.send(:glob_to_regexp, "*.escad")
      expect("foo.escad").to match(re)
      expect("bar.escad").to match(re)
      expect("foo.txt").not_to match(re)
    end

    it "escapes dots and matches literal dots" do
      re = watcher.send(:glob_to_regexp, "test.*.escad")
      expect("test.foo.escad").to match(re)
      expect("test..escad").to match(re)
      expect("testescad").not_to match(re)
    end

    it "matches the whole string (anchors)" do
      re = watcher.send(:glob_to_regexp, "foo.*")
      expect("foo.bar").to match(re)
      expect("foo.bar.baz").to match(re)
      expect("afoo.bar").not_to match(re)
      expect("foo.bar.baz.txt").to match(re)
    end
  end

  describe ".main" do
    let(:dummy_bin) { "/bin/echo" }
    let(:filetype_globs) { ["test/*.escad"] }
    let(:watch_globs) { ["test/*.escad"] }
    let(:render_cmd_template) { ->(bin, src, dest) { "#{bin} #{src} #{dest}" } }

    before do
      stub_const("ARGV", ["--bin-name", "echo", "--debug"])
      allow(CadWatcher).to receive(:config_from_argv).and_return({
        bin_name: "echo",
        bin_paths: [dummy_bin],
        filetype_globs: filetype_globs,
        watch_globs: watch_globs,
        render_cmd_template: render_cmd_template,
        debug_mode: true,
      })
    end

    it "runs without error and calls first_run and start" do
      real_instance = CadWatcher.new(
        bin_paths: [dummy_bin],
        filetype_globs: filetype_globs,
        watch_globs: watch_globs,
        render_cmd_template: render_cmd_template,
        debug_mode: true,
      )
      allow(CadWatcher).to receive(:new).and_return(real_instance)
      expect(real_instance).to receive(:first_run).and_call_original
      # Stub out Listen.to and sleep to prevent blocking
      allow(Listen).to receive(:to).and_return(double("listener", only: nil, start: nil))
      allow(real_instance).to receive(:sleep)
      expect { CadWatcher.main }.not_to raise_error
    end
  end
end
