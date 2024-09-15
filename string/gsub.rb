
require 'benchmark/ips'

key = "FORCE_RUBY_PLATFORM"
Benchmark.ips do |x|
  x.report "gsub with regex" do
    key.gsub(/___/, "-")
  end

  x.report "gsub with string" do
    key.gsub('___', "-")
  end

  x.compare!
end
