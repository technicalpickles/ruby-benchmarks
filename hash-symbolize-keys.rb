require 'benchmark/ips'
require 'benchmark/memory'

require 'active_support/core_ext/hash/keys'

class Hash
   def graphviz_symbolize_keys
      inject({}) do |options, (key, value)|
         options[(key.to_sym rescue key) || key] = value
      options
      end
   end
end

hash = { 'name' => 'Rob', 'age' => '28', :foo => 'bar' }

puts "==IPS"
Benchmark.ips do |x|
  x.report("graphviz_symbolize_keys") do
    hash.graphviz_symbolize_keys
  end

  x.report("activesupport_symbolize_keys") do
    hash.symbolize_keys
  end

  x.compare!
end
puts ""

puts "==MEMORY"
Benchmark.memory do |x|
  x.report("graphviz_symbolize_keys") do
    hash.graphviz_symbolize_keys
  end

  x.report("activesupport_symbolize_keys") do
    hash.symbolize_keys
  end

  x.compare!
end
