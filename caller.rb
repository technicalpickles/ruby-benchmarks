require 'benchmark/ips'
require 'stack_frames'

STACK_FRAMES_BUFFER = StackFrames::Buffer.new(500)

def recurse(n, &block)
  if n > 0
    recurse(n - 1, &block)
  else
    yield
  end
end

recurse(1000) do
  Benchmark.ips do |x|
    x.config(time: 5, warmup: 1)

    x.report("caller") { caller }
    x.report("caller(1, 500)") { caller(1, 500) }
    x.report("stack_frames") { STACK_FRAMES_BUFFER.capture }

    x.compare!
  end
end
