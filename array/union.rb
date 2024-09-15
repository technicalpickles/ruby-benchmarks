require 'benchmark/ips'
require 'benchmark/memory'

a = [1,2,3]
b = [2,3,4]
c = [3,4,5]

Benchmark.ips do |x|
  x.report "|" do
    a | b | c
  end

  x.report "Array#union" do
    a.union(b, c)
  end

  x.compare!
end

Benchmark.memory do |x|
  x.report "|" do
    a | b | c
  end

  x.report "Array#union" do
    a.union(b, c)
  end

  x.compare!
end
