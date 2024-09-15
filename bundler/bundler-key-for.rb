# forzen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'

def original(key)
  key = key.to_s.gsub(".", "__").gsub("-", "___").upcase
  "BUNDLE_#{key}"
end

def bang_methods(key)
  key = key.to_s.gsub(".", "__")
  key.gsub!("-", "___")
  key.upcase!
  "BUNDLE_#{key}"
end

def bang_methods_and_prepend(key)
  key = key.to_s.gsub(".", "__")
  key.gsub!("-", "___")
  key.upcase!
  key.prepend("BUNDLE_")
end

puts "== Memory"
Benchmark.memory do |x|
  x.report("original") { original(:force_ruby_platform) }
  x.report("bang_methods") { bang_methods(:force_ruby_platform) }
  x.report("bang_methods_and_prepend") { bang_methods_and_prepend(:force_ruby_platform) }

  x.compare!
end
puts

puts "== IPS"
Benchmark.ips do |x|
  x.warmup = 0
  x.report("original") { original(:force_ruby_platform) }
  x.report("bang_methods") { bang_methods(:force_ruby_platform) }
  x.report("bang_methods_and_prepend") { bang_methods_and_prepend(:force_ruby_platform) }

  x.compare!(order: :baseline)
end

