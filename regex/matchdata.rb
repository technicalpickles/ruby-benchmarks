require 'benchmark/ips'
require 'benchmark/memory'

PER_URI_OPTIONS = %w[
  fallback_timeout
].freeze

NORMALIZE_URI_OPTIONS_PATTERN =
  /
    \A
    (\w+\.)? # optional prefix key
    (https?.*?) # URI
    (\.#{Regexp.union(PER_URI_OPTIONS)})? # optional suffix key
    \z
  /ix.freeze

uri = "https://rubygems.org/"


Benchmark.memory do |x|
  x.report "regex with constant and $ variables" do
    if uri =~ NORMALIZE_URI_OPTIONS_PATTERN
      prefix = $1
      uri = $2
      suffix = $3
    end
  end

  x.report "string#match with matchdata" do
    if m = uri.match(NORMALIZE_URI_OPTIONS_PATTERN)
      prefix = m[1]
      uri = m[2]
      suffix = m[3]
    end
  end

  x.compare!
end

Benchmark.ips do |x|
  x.report "regex with constant and $ variables" do
      if uri =~ NORMALIZE_URI_OPTIONS_PATTERN
        prefix = $1
        uri = $2
        suffix = $3
      end
  end

  x.report "string#match with matchdata" do
    if m = uri.match(NORMALIZE_URI_OPTIONS_PATTERN)
      prefix = m[1]
      uri = m[2]
      suffix = m[3]
    end
  end

  x.compare!
end
