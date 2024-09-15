# forzen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'
def to_bool(value)
  case value
  when nil, /\A(false|f|no|n|0|)\z/i, false
    false
  else
    true
  end
end

def to_bool_match(value)
  case value
  when String
   if value.match?(/\A(false|f|no|n|0|)\z/i)
     false
   else
     true
   end
  when nil, false, 
    false
  else
    true
  end
end

def to_bool_match_negate(value)
  case value
  when String
    !value.match?(/\A(false|f|no|n|0|)\z/i)
  when nil, false, 
    false
  else
    true
  end
end

BOOL_REGEX = /\A(false|f|no|n|0|)\z/i.freeze
def to_bool_constant_regex(value)
  case value
  when nil, BOOL_REGEX, false
    false
  else
    true
  end
end

def to_bool_regexless(value)
  def to_bool(value)
    case value.downcase
    when "false", "f", "no", "n", "0", ""
      false
    else
      true
    end
  end
end

puts "== Memory"
Benchmark.memory do |x|
  x.report("original") { to_bool("false") }
  x.report("regexless") { to_bool_regexless("false") }
  x.report("constant regex") { to_bool_constant_regex("false") }
  x.report("match if/else") { to_bool_match("false") }
  x.report("match negate") { to_bool_match_negate("false") }

  x.compare!
end
puts

puts "== IPS"
Benchmark.ips do |x|
  x.warmup = 0
  x.report("original") { to_bool("false") }
  x.report("regexless") { to_bool_regexless("false") }
  x.report("constant regex") { to_bool_constant_regex("false") }
  x.report("match if/else") { to_bool_match("false") }
  x.report("match negate") { to_bool_match_negate("false") }

  x.compare!(order: :baseline)
end

