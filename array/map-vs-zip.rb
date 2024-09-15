require 'benchmark/ips'
require 'benchmark/memory'

arrays = {
  small: (1..4).to_a,
  medium: (1..1000).to_a,
  big: (1..50000).to_a,
}

arrays.each do |size, array|
  puts "=== #{size} ==="
  Benchmark.ips do |x|
    x.report(".map { |id| [id] }:") do
      array.map { |id| [id] }
    end

    x.report(".zip:") do
      array.zip
    end

    x.compare! order: :baseline
  end

  Benchmark.memory do |x|
    x.report(".map { |id| [id] }:") do
      array.map { |id| [id] }
    end

    x.report(".zip:") do
      array.zip
    end
  end
end
