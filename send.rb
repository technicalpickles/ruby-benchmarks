# https://github.com/fastruby/fast-ruby/blob/main/code/general/block-apply-method.rb
require "benchmark/ips"

def do_something(n)
  n.to_s
end

def fast
  [1, 2, 3].map { |n| do_something(n) }
end

def slow
  [1, 2, 3].map(&method(:do_something))
end

def wo_ampersand
  [1, 2, 3].map {|i| i.to_s }
end

def ampersand
  [1, 2, 3].map(&:to_s)
end

Benchmark.ips do |x|
  # x.report("normal")  { fast }
  # x.report("&method") { slow }
  x.report("block") { wo_ampersand }
  x.report("&") { ampersand }

  x.compare! order: :baseline
end
