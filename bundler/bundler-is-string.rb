# frozen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'

STRING_KEYS = %w[
  bin
  cache_path
  console
  gem.ci
  gem.github_username
  gem.linter
  gem.rubocop
  gem.test
  gemfile
  path
  shebang
  system_bindir
  trust-policy
  version
].freeze

def original(name)
      STRING_KEYS.include?(name.to_s) || name.to_s.start_with?("local.") || name.to_s.start_with?("mirror.") || name.to_s.start_with?("build.")
end

def one_to_s(name)
  name = name.to_s
  STRING_KEYS.include?(name) || name.start_with?("local.") || name.start_with?("mirror.") || name.start_with?("build.")
end

def one_to_s_one_start_with?(name)
  name = name.to_s
  STRING_KEYS.include?(name) || name.start_with?("local.", "mirror.", "build.")
end

puts "== IPS"
Benchmark.ips do |x|
  x.warmup = 0
  x.report("original") { original(:something) }
  x.report("only one to_s") { one_to_s(:something) }
  x.report("only one to_s and one start_with?") { one_to_s_one_start_with?(:something) }

  x.compare! order: :baseline
end
puts

puts "== Memory"
Benchmark.memory do |x|
  x.report("original") { original(:something) }
  x.report("only one to_s") { one_to_s(:something) }
  x.report("only one to_s and one start_with?") { one_to_s_one_start_with?(:something) }

  x.compare!
end
