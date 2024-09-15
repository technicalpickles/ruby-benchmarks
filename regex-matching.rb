# frozen_string_literal: true
require 'benchmark/ips'
require 'benchmark/memory'

uri = "https://rubygems.org/"


Benchmark.memory do |x|
  x.report "=~ regex with capture group" do
    uri =~ /^(http)/
  end

  x.report "=~ regex without capture group" do
    uri =~ /^http/
  end

  x.report "String#match with capture group" do
    uri.match(/^(http)/)
  end

  x.report "String#match without capture group" do
    uri.match(/^http/)
  end

  x.report "String#match? with capture group" do
    uri.match?(/^(http)/)
  end

  x.report "String#match without capture group" do
    uri.match?(/^http/)
  end

  x.report "String#start_with?" do
    uri.start_with?("http")
  end

  x.compare!
end

Benchmark.ips do |x|
  x.report "=~ regex with capture group" do
    uri =~ /^(http)/
  end

  x.report "=~ regex without capture group" do
    uri =~ /^http/
  end

  x.report "String#match with capture group" do
    uri.match(/^(http)/)
  end

  x.report "String#match without capture group" do
    uri.match(/^http/)
  end

  x.report "String#match? with capture group" do
    uri.match?(/^(http)/)
  end

  x.report "String#match? without capture group" do
    uri.match?(/^http/)
  end

  x.report "String#start_with?" do
    uri.start_with?("http")
  end

  x.compare! order: :baseline
end
