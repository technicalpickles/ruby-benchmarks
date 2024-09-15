require 'benchmark/memory'
require 'benchmark/ips'
require 'date'

effective_from = Date.new(2016, 1, 1)
date = Date.new(2017, 1, 1)
effective_to = Date.new(2018, 1, 1)


Benchmark.memory do |x|
  x.report("cover?") { (effective_from..effective_to).cover?(date) }
  x.report("compare") { effective_from <= date && effective_to >= date }

  x.compare!
end

Benchmark.ips do |x|
  x.report("cover?") { (effective_from..effective_to).cover?(date) }
  x.report("compare") { effective_from <= date && effective_to >= date }

  x.compare!(order: :baseline)
end
