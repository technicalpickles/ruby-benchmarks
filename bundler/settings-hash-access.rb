require "benchmark/ips"
require "benchmark/memory"

require 'bundler'
class Bundler::Settings
  def original(name)
    key = key_for(name)
    value = configs.values.map {|config| config[key] }.compact.first

    converted_value(value, name)
  end

  def bang_method(name)
    key = key_for(name)

    values = configs.values
    values.map! {|config| config[key] }
    values.compact!
    value = values.first

    converted_value(value, name)
  end

  def with_detect(name)
    key = key_for(name)
    config_with_key = configs.values.detect {|config| config[key] }
    value = config_with_key[key] if config_with_key

    converted_value(value, name)
  end

  def with_detect_with_memoized_configs(name)
    key = key_for(name)
    config_with_key = configs.values.detect {|config| config[key] }
    value = config_with_key[key] if config_with_key

    converted_value(value, name)
  end

  def manual_loop(name)
    key = key_for(name)
    value = nil
    configs.each do |_, config|
      if config[key]
        value = config[key]
        break
      end
    end
    converted_value(value, name)
  end


  def manual_loop_with_memoized_configs(name)
    key = key_for(name)
    value = nil
    memoized_configs.each do |_, config|
      if config[key]
        value = config[key]
        break
      end
    end
    converted_value(value, name)
  end

  def correct_manual_loop(name)
    key = key_for(name)
    value = nil
    configs.each do |_, config|
      value = config[key]
      next if value.nil?
      break
    end
    converted_value(value, name)
  end

  def correct_manual_loop_with_memoized_configs(name)
    key = key_for(name)
    value = nil
    memoized_configs.each do |_, config|
      value = config[key]
      next if value.nil?
      break
    end
    converted_value(value, name)
  end

  def correct_manual_with_each_config(name)
    key = key_for(name)
    value = nil
    each_config do |config|
      value = config[key]
      next if value.nil?
      break
    end
    converted_value(value, name)
  end

  def with_flat_map(name)
    key = key_for(name)
    value = configs.flat_map {|_, config| break config[key] unless config[key].nil? }

    converted_value(value, name)
  end

  private

  def each_config
    yield @temporary
    yield @local_config
    yield @env_config
    yield @global_config
    yield DEFAULT_CONFIG
  end


    def memoized_configs
      @memoized_configs ||= {
        :temporary => @temporary,
        :local => @local_config,
        :env => @env_config,
        :global => @global_config,
        :default => DEFAULT_CONFIG,
      }.freeze
    end

end

# warm up memoization
Bundler.settings.manual_loop_with_memoized_configs(:silence_deprecations)

Benchmark.memory do |x|
  x.report("original") { Bundler.settings.original(:force_ruby_platform) }
  x.report("bang_method") { Bundler.settings.bang_method(:force_ruby_platform) }
  x.report("with_detect") { Bundler.settings.with_detect(:force_ruby_platform) }
  x.report("with_detect w/ memoized configs") { Bundler.settings.with_detect_with_memoized_configs(:force_ruby_platform) }
  x.report("manual_loop") { Bundler.settings.manual_loop(:force_ruby_platform) }
  x.report("manual_loop w/ memoized configs") { Bundler.settings.manual_loop_with_memoized_configs(:force_ruby_platform) }
  x.report("correct manual_loop") { Bundler.settings.correct_manual_loop(:force_ruby_platform) }
  x.report("correct manual_loop w/ memoized configs") { Bundler.settings.correct_manual_loop_with_memoized_configs(:force_ruby_platform) }
  x.report("correct manual_loop w/ each_config") { Bundler.settings.correct_manual_with_each_config(:force_ruby_platform) }
  x.report("with_flat_map") { Bundler.settings.with_flat_map(:force_ruby_platform) }

  x.compare!
end

Benchmark.ips do |x|
  x.report("original") { Bundler.settings.original(:force_ruby_platform) }
  x.report("bang_method") { Bundler.settings.bang_method(:force_ruby_platform) }
  x.report("with_detect") { Bundler.settings.with_detect(:force_ruby_platform) }
  x.report("with_detect w/ memoized configs") { Bundler.settings.with_detect_with_memoized_configs(:force_ruby_platform) }
  x.report("manual_loop") { Bundler.settings.manual_loop(:force_ruby_platform) }
  x.report("manual_loop w/ memoized configs") { Bundler.settings.manual_loop_with_memoized_configs(:force_ruby_platform) }
  x.report("correct manual_loop") { Bundler.settings.correct_manual_loop(:force_ruby_platform) }
  x.report("correct manual_loop w/ memoized configs") { Bundler.settings.correct_manual_loop_with_memoized_configs(:force_ruby_platform) }
  x.report("correct manual_loop w/ each_config") { Bundler.settings.correct_manual_with_each_config(:force_ruby_platform) }
  x.report("with_flat_map") { Bundler.settings.with_flat_map(:force_ruby_platform) }

  x.compare! order: :baseline
end
