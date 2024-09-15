# frozen_string_literal: true
require 'benchmark/ips'

lowercase_string = 'accept'
lowercase_symbol = :accept
uppercase_string = 'ACCEPT'
uppercase_symbol = :ACCEPT

Benchmark.ips do |x|
  x.report "Symbol#downcase.to_s" do
    lowercase_symbol.downcase.to_s
  end

  x.report "Symbol#to_s.downcase" do
    lowercase_symbol.to_s.downcase
  end


  x.report "String#downcase.to_s" do
    lowercase_string.downcase.to_s
  end

  x.report "String#to_s.downcase" do
    lowercase_string.to_s.downcase
  end

  x.report "String#to_s.tr" do
    lowercase_string.to_s.tr('A-Z', 'a-z')
  end

  x.compare!
end
