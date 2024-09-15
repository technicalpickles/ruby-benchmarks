require 'memory_profiler'
require 'benchmark/ips'


def literal(string)
  string.match?(/foo-bar/)
end

REGEX = /foo-bar/
def reused_instance(string)
  string.match?(REGEX)
end

REGEX_FROZEN = /foo-bar/.freeze
def reused_instance_frozen(string)
  string.match?(REGEX_FROZEN)
end

input = "foo-bar"

puts "##### literal"
MemoryProfiler.report do
    literal(input)
end.pretty_print(detailed_report: true)
puts

puts "##### reused instance"
MemoryProfiler.report do
  reused_instance(input)
end.pretty_print(detailed_report: true)
puts

puts "##### reused instance frozen"
MemoryProfiler.report do
  reused_instance_frozen(input)
end.pretty_print(detailed_report: true)

Benchmark.ips do |x|
  x.report "literal" do
    literal(input)
  end

  x.report "reused instance" do
    reused_instance(input)
  end

  x.report "reused instance frozen" do
    reused_instance_frozen(input)
  end
end
