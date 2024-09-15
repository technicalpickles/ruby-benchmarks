require 'json'
require 'memory_profiler'
require 'benchmark/ips'

module MemoryProfiler
  class Results
    def pretty_print(io = $stdout, **options)
      # Handle the special case that Ruby PrettyPrint expects `pretty_print`
      # to be a customized pretty printing function for a class
      return io.pp_object(self) if defined?(PP) && io.is_a?(PP)

      io = File.open(options[:to_file], "w") if options[:to_file]

      color_output = options.fetch(:color_output) { io.respond_to?(:isatty) && io.isatty }
      @colorize = color_output ? Polychrome.new : Monochrome.new

      if options[:scale_bytes]
        total_allocated_output = scale_bytes(total_allocated_memsize)
        total_retained_output  = scale_bytes(total_retained_memsize)
      else
        total_allocated_output = "#{total_allocated_memsize} bytes"
        total_retained_output  = "#{total_retained_memsize} bytes"
      end

      io.puts "Total allocated: #{total_allocated_output} (#{total_allocated} objects)"
      io.puts "Total retained:  #{total_retained_output} (#{total_retained} objects)"
    end
  end
end


def parse_with_object_class_from_hash_to_json
  hash = {
    foo:
    {
      bar: 5,
      baz: 6,
    }
  }

  json_result = JSON.parse(hash.to_json, object_class: OpenStruct)
end

def construct_open_struct_directly
  open_struct_constructed = OpenStruct.new(
    foo: OpenStruct.new({
      bar: 5,
      baz: 6,
    })
  )
end

iterations = 5
puts "##### JSON.parse with object_class from a Hash#to_json"
MemoryProfiler.report do
  iterations.times do 
    parse_with_object_class_from_hash_to_json
  end
end.pretty_print
puts

puts "##### construct OpenStruct directly"
MemoryProfiler.report do
  iterations.times do
    construct_open_struct_directly
  end
end.pretty_print

# Benchmark.ips do |x|
#   x.report("JSON.parse with object_class from a Hash#to_json") do
#     parse_with_object_class_from_hash_to_json
#   end
#
#   x.report("construct OpenStruct directly") do
#     construct_open_struct_directly
#   end
# end
