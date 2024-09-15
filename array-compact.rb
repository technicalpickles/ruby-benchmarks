require 'benchmark/ips'
require 'benchmark/memory'

require 'listen'

class Listen::Record::Entry
  def sys_path
    ::File.join(*[@root, @relative, @name].compact)
  end

  def sys_path_freeze
    ::File.join(*[@root, @relative, @name].compact.freeze)
  end

  def sys_path_compact_bang
    args = [@root, @relative, @name]
    args.compact!
    ::File.join(*args)
  end

  def sys_path_splatless
    if @name
      File.join(@root, @relative, @name)
    else
      File.join(@root, @relative)
    end
  end
end

file = Listen::Record::Entry.new("/home/me/watched_dir", "app/models", "foo.rb")
dir = Listen::Record::Entry.new("/home/me/watched_dir", "app/models", nil)

[file, dir].each do |entry|
  puts "entry.sys_path: #{entry.sys_path}"
  Benchmark.memory do |x|
    x.report("compact") do
      entry.sys_path
    end

    x.report("compact!") do
      entry.sys_path_compact_bang
    end

    x.report("compact.freeze") do
      entry.sys_path_freeze
    end

    x.report("without splat") do
      entry.sys_path_freeze
    end

    x.compare!
  end

  Benchmark.ips do |x|
    x.report("compact") do
      entry.sys_path
    end

    x.report("compact!") do
      entry.sys_path_compact_bang
    end

    x.report("compact.freeze") do
      entry.sys_path_freeze
    end

    x.report("without splat") do
      entry.sys_path_freeze
    end

    x.compare! order: :baseline
  end
end

