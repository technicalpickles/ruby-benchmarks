# frozen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'

class Entry
  # file: "/home/me/watched_dir", "app/models", "foo.rb"
  # dir, "/home/me/watched_dir", "."
  def initialize(root, relative, name = nil)
    @root = root
    @relative = relative
    @name = name
  end

  def record_dir_key
    ::File.join(*[@relative, @name].compact)
  end

  def refactored_record_dir_key
    if @relative && @name
      File.join(@relative, @name)
    elsif @relative
      @relative
    else
      ""
    end
  end

  def sys_path
    # Use full path in case someone uses chdir
    ::File.join(*[@root, @relative, @name].compact)
  end

  def refactored_sys_path
    if @relative && @name
      File.join(@root, @relative, @name)
    elsif @relative
      File.join(@root, @relative)
    else
      @root
    end
  end
end


entry = Entry.new("/home/me/watched_dir", "app/models", "foo.rb")

puts "== record_dir_key"
Benchmark.memory do |x|
  x.report("original") { entry.record_dir_key }
  x.report("refactored") { entry.refactored_record_dir_key }
  x.compare!
end
puts

puts "== record_dir_key"
Benchmark.memory do |x|
  x.report("original") { entry.sys_path }
  x.report("refactored") { entry.refactored_sys_path }
  x.compare!
end
