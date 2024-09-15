require 'benchmark/ips'
positive = "content-type"
negative = "content"
Benchmark.ips do |x|
  x.report("positive String#match? with string") do
    positive.match?("-")
  end

  x.report("positive String#match? with regex") do
    positive.match?(/-/)
  end

  x.report("negative String#match? with string") do
    negative.match?("-")
  end

  x.report("negative String#match? with regex") do
    negative.match?(/-/)
  end
end
#
# Warming up --------------------------------------
# positive String#match? with string
#                        237.947k i/100ms
# positive String#match? with regex
#                          1.130M i/100ms
# negative String#match? with string
#                        246.167k i/100ms
# negative String#match? with regex
#                          1.313M i/100ms
# Calculating -------------------------------------
# positive String#match? with string
#                           2.384M (± 1.1%) i/s -     12.135M in   5.091989s
# positive String#match? with regex
#                          11.236M (± 0.7%) i/s -     56.486M in   5.027408s
# negative String#match? with string
#                           2.449M (± 1.1%) i/s -     12.308M in   5.027558s
# negative String#match? with regex
#                          13.231M (± 0.8%) i/s -     66.974M in   5.062258s


require 'benchmark/ips'
positive = "content-type"
negative = "content"

Benchmark.ips do |x|
  x.report("positive String#split with string") do
    positive.split("-")
  end

  x.report("positive String#split with regex") do
    positive.split(/-/)
  end

  x.report("negative String#split with string") do
    negative.split("-")
  end

  x.report("negative String#split with regex") do
    negative.split(/-/)
  end
end
# Warming up --------------------------------------
# positive String#split with string
#                        514.296k i/100ms
# positive String#split with regex
#                        246.044k i/100ms
# negative String#split with string
#                        688.986k i/100ms
# negative String#split with regex
#                        563.511k i/100ms
# Calculating -------------------------------------
# positive String#split with string
#                           5.246M (± 0.9%) i/s -     26.743M in   5.098397s
# positive String#split with regex
#                           2.457M (± 1.1%) i/s -     12.302M in   5.007277s
# negative String#split with string
#                           6.861M (± 0.6%) i/s -     34.449M in   5.021461s
# negative String#split with regex
#                           5.605M (± 0.9%) i/s -     28.176M in   5.027227s
