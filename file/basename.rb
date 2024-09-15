require 'benchmark/ips'
require 'benchmark/memory'

def original(path)
  path.split('/').last[0..1]
end

def basename(path)
  File.basename(path, ".*")
end

Benchmark.memory do |x|
  x.report("original") { original("foo/bar/baz.yml") }
  x.report("basename") { basename("foo/bar/baz.yml") }

  x.compare!
end

Benchmark.ips do |x|
  x.report("original") { original("foo/bar/baz.yml") }
  x.report("basename") { basename("foo/bar/baz.yml") }

  x.compare!
end
