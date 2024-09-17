require 'benchmark/ips'
require 'benchmark/memory'
require 'colorize'

arrays = {
  small: (1..4).to_a,
  medium: (1..1000).to_a,
  big: (1..50000).to_a,
}

arrays.each do |size, array|
  puts "=== #{size} ===".blue.bold
  Benchmark.ips do |x|
    x.report(".map { |id| [id] }:") do
      array.map { |id| [id] }
    end

    x.report(".zip:") do
      array.zip
    end

    x.report(".each_with_object([]) {|id, object| object << [id]}:") do
      array.each_with_object([]) {|id, object| object << [id]}
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

    x.report(".each_with_object([]) {|id, object| object << [id]}:") do
      array.each_with_object([]) {|id, object| object << [id]}
    end
  end
end
