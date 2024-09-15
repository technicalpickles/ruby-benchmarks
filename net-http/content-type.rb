require 'benchmark/ips'
require 'net/http'

content_type = "application/json; charset=utf-8"

class Current
  include Net::HTTPHeader
  def initialize
    initialize_http_header({"content-type" => "application/json; charset=utf-8"})
  end
end

class Refactored
  include Net::HTTPHeader
  def initialize
    initialize_http_header({"content-type" => "application/json; charset=utf-8"})
  end

  def content_type
    main = main_type()
    return nil unless main

    sub = sub_type
    if sub
      "#{main}/#{sub}"
    else
      main
    end
  end
end

Benchmark.ips do |x|
  x.report "content_type current" do
    Current.new.content_type
  end

  x.report "content_type refactored" do
    Refactored.new.content_type
  end

  x.compare!
end
# Warming up --------------------------------------
# content_type current    27.752k i/100ms
# content_type refactored
#                         45.404k i/100ms
# Calculating -------------------------------------
# content_type current    281.205k (± 0.7%) i/s -      1.415M in   5.033402s
# content_type refactored
#                         452.947k (± 0.8%) i/s -      2.270M in   5.012417s
# 
# Comparison:
# content_type refactored:   452946.6 i/s
# content_type current:   281205.3 i/s - 1.61x  slower



# def main_type_current(content_type)
#   content_type.split(';').first.split('/').first.to_s.strip
# end
#
# def main_type_regex(content_type)
#   type_match = content_type.match(/([^\/]+)/)
#   type_match[1]
# end
#
# MAIN_TYPE_REGEX = /([^\/]+)/.freeze
# def main_type_regex(content_type)
#   type_match = content_type.match(MAIN_TYPE_REGEX)
#   return nil unless type_match
#   type_match[1]
# end
#
# def sub_type_current(content_type)
#     _, sub = *content_type.split(';').first.split('/')
#     return nil unless sub
#     sub.strip
# end
#
#
# def sub_type_refactored(content_type)
#   type_match = content_type.match(/[^\/]+\/([^;]+)/)
#   type_match[1]
# end
#
# SUB_TYPE_REGEX = /[^\/]+\/([^;]+)/.freeze
# def sub_type_refactored_frozen(content_type)
#   type_match = content_type.match(SUB_TYPE_REGEX)
#   return nil unless type_match
#   type_match[1]
# end

# raise "fail" unless main_type_current(content_type) == "application"
# raise "fail" unless main_type_regex(content_type) == "application"
#
# raise "fail" unless sub_type_current(content_type) == "json"
# raise "fail" unless sub_type_refactored(content_type) == "json"


Benchmark.ips do |x|
  x.report "content_type current" do
    Current.new.content_type
  end

  x.report "content_type refactored" do
    Refactored.new.content_type
  end
#
  x.compare!
end
