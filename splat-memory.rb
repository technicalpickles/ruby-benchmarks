require 'benchmark/memory'

def splat_demo(*args)
  args
end

def empty(*args)
end

def splat_delegate(*args)
  empty(*args)
end

def dot_dot_dot_delegate(...)
  empty(...)
end

def splatless_demo(args)
  args
end

args = [1, 2, 3]
Benchmark.memory do |x|
  x.report('splat with splat array') { splat_demo(*args) }
  x.report('splat without splat array') { empty(*args) }
  x.report('splat with delegating') { splat_delegate(*args) }
  x.report('... delegating') { dot_dot_dot_delegate(*args) }
  x.report('splatless method') { splatless_demo(args) }

  x.compare!
end
