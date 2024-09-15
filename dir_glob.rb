require 'benchmark/ips'
require 'find'
require 'debug'

Dir.chdir ARGV[0] if ARGV[0]


focus_dirs = %w(app components config frontend lib packs spec danger script)
focus_types = %w(rb arb erb rake js jsx ts tsx)
glob = "{#{focus_dirs.join(",")}}/**/*.{#{focus_types.join(",")}}"
dir_glob = lambda do
  Dir.glob glob
end

exclude_dirs = [
  # only actually include gusto-apis ... but this is easier for right now
  "components/rails-backports",
  "components/bank_files",
  "components/gusto_faker",
  "components/gusto_sorbet",
  "components/db_extraction",
  "components/payroll_taxes",
  "components/pony",
  "components/custom_cops",
  "components/agent_zen",
  "components/unit21",
  "components/bai2",
  "components/gusto-authorization",
  "components/mantis",
  "components/penguin",
  "components/tax_data_scraper",
  "components/payroll_language",
  "components/filing_data_generator",
  "components/corpnet",
  "components/gusto_rspec_matchers",
  "components/cancancan",
  "components/gusto-instrumentation",
  "components/rspec-retryable",
  "components/teuthologist",
  "components/value_object",
  "components/activeadmin",
  "components/dev_setup",
  "components/gusto-deprecation",
  "components/amendment_needed_decider",
  "components/payroll_reference_data",
  "components/bucketing",
  "components/fifteen_five",
  "components/ensenta_api",
  "components/gusto_teams",
  "components/attr_encrypted",
  "components/two_factor_authentication",
  "components/proto_utils",
  "components/gusto-kafka-common",

  "app/assets",
  "sorbet/rbi",
]

exclude_subpath_dirs = [
  "rbi"
]

fd = lambda do
  `fd --full-path --glob '**/*.{rb,arb,erb,rake,js,jsx,ts,tsx}' | grep -e '^app/' -e '^components/' -e '^config' -e '^frontend/' -e '^lib/' -e '^packs/' -e '^spec/' -e '^danger/' -e '^script/'`.split
end

file_regex = /\.(rb|arb|erb|rake|js|jsx|ts|tsx)$/
dir_regex = /\.\/(app|components|config|frontend|lib|packs|spec|danger|script)(?:\/|$)/
exclude_dirs_with_prefix = exclude_dirs.map { |dir| File.join("./#{dir}") }
exclude_dirs_regex = /^(?:#{exclude_dirs_with_prefix.join("|")})$/

find = lambda do
  files = []

  Find.find('.') do |path|
    # puts "checking #{path}"
    if path == '.'
      next
    end

    if File.directory?(path)
      # debugger if path == "./.git"
      if (path.match?(exclude_dirs_regex) || !path.match?(dir_regex))
        # puts "** pruning #{path} and its children. reason: #{path.match?(exclude_dirs_regex) ? "exclude_dirs_regex" : "dir_regex"}"
        # technically this throws, so don't need return but maybe it is a little more clear?
        return Find.prune
      end
    end

    if File.file?(path) && path.match?(file_regex)
      files << path
    end
  end
  files
end

# puts find.call

Benchmark.ips do |x|
  x.config warmup: 0

  x.report "Dir.glob" do
    dir_glob.call
  end

  x.report "find" do
    find.call
  end

#   x.report "fd" do |x|
#     fd.call
#   end

  x.compare! order: :baseline
end

# dir_glob_results = dir_glob.call
# fd_results = fd.call
# if dir_glob.call != fd.call
#   puts "Results are different"
#   puts "Dir.glob: #{dir_glob_results.size}"
#   puts "fd: #{fd_results.size}"
#
#   puts dir_glob_results.intersection(fd_results)
# end
