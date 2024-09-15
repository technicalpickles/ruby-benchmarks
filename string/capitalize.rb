# frozen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'

def original(name)
  name.to_s.split(/-/).map {|s| s.capitalize }.join('-')
end

def string(name)
  name.to_s.split('-').map {|s| s.capitalize }.join('-')
end

def each_capitalize_bang(name)
  name.to_s.split('-').each {|s| s.capitalize! }.join('-')
end

def capitalize_bang(name)
  name.to_s.split('-').map {|s| s.capitalize! || s }.join('-')
end

def map_bang(name)
  name.to_s.split('-').map! {|s| s.capitalize }.join('-')
end

def map_bang_capitalize_bang_or(name)
  name.to_s.split('-').map! {|s| s.capitalize! || s }.join('-')
end

def map_bang_capitalize_bang_semicolon(name)
  name.to_s.split('-').map! {|s| s.capitalize!; s }.join('-')
end

def gsub(name)
  name.to_s.gsub(/([^-]+)/) {|s| s.capitalize }
end

def gsub_alt(name)
  name.to_s.gsub(/(\A|(?<=[\^\-]))([a-z])/) do |c|
    c.upcase!
    c
  end
end

lowercase_input_dash = "sec-ch-ua-full-version-list"

report = lambda do |x|
  x.report "original" do
    original(lowercase_input_dash)
  end

  x.report "string split" do
    string(lowercase_input_dash)
  end

  x.report "each capitalize!" do
    each_capitalize_bang(lowercase_input_dash)
  end

  x.report "capitalize!" do
    capitalize_bang(lowercase_input_dash)
  end

  x.report "map!" do
    map_bang(lowercase_input_dash)
  end

  x.report "map! with capitalize! & logical or" do
    map_bang_capitalize_bang_or(lowercase_input_dash)
  end

  x.report "map! capitalize! & two statements" do
    map_bang_capitalize_bang_semicolon(lowercase_input_dash)
  end

  x.report "gsub" do
    gsub(lowercase_input_dash)
  end

  x.report "gsub alt" do
    gsub_alt(lowercase_input_dash)
  end

  x.compare!(order: :baseline)
end

Benchmark.ips(&report)
Benchmark.memory(&report)
