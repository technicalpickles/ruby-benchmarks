# frozen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'

class MethodSet
  def initialize
    @sources = [
      "puts 'hello'",
      "puts 'world'",
      "puts 'itsa'",
      "puts 'me'",
      "puts 'mario'",
    ]
  end

  def original
    code = "# frozen_string_literal: true\n" + @sources.join(";")
  end

  def refactored
    code = "# frozen_string_literal: true\n#{@sources.join(";")}"
  end

  def refactored2
    code = String.new("# frozen_string_literal: true\n")
    @sources.each { |source| code.concat(source).concat(";") }
    code
  end
end



method_set = MethodSet.new
Benchmark.memory do |x|
  x.report("original") do
    method_set.original
  end

  x.report("refactored") do
    method_set.refactored
  end

  x.report("refactored2") do
    method_set.refactored2
  end

  x.compare!
end

Benchmark.ips do |x|
  x.report("original") do
    method_set.original
  end

  x.report("refactored") do
    method_set.refactored
  end

  x.report("refactored2") do
    method_set.refactored2
  end

  x.compare! order: :baseline
end
