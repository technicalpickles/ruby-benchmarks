# frozen_string_literal: true
require 'action_controller'
require 'benchmark/ips'
require 'benchmark/memory'

puts "ActionPack.version = #{ActionPack.version}"

module Actions
  def foo
  end

  def bar
  end

  def baz
  end
end

class Current < ActionController::Base
  include Actions
  def action_methods
    @action_methods ||= begin
      # All public instance methods of this class, including ancestors
      methods = (public_instance_methods(true) -
        # Except for public instance methods of Base and its ancestors
        internal_methods +
        # Be sure to include shadowed public instance methods of this class
        public_instance_methods(false))

      methods.map!(&:to_s)

      methods.to_set
    end
  end
end

class Refactored < ActionController::Base
  include Actions

  class << self
      def action_methods
        @action_methods ||= begin
                              methods = Set.new
                              methods.merge(public_instance_methods(true))
                              methods.subtract(internal_methods)
                              methods.merge(public_instance_methods(false))
                              methods.map!(&:to_s)
        end
      end
  end
end

class Refactored2 < ActionController::Base
  include Actions

  class << self
      def action_methods
        @action_methods ||= begin
                              Set.new(public_instance_methods(true))
                                .subtract(internal_methods)
                                .merge(public_instance_methods(false))
                                .map!(&:to_s)
        end
      end
  end
end

class Refactored3 < ActionController::Base
  include Actions

  class << self
      def action_methods
        @action_methods ||= begin
                              methods = public_instance_methods(true) - internal_methods
                              methods.concat(public_instance_methods(false))
                              methods.map!(&:to_s)
                              methods.to_set
        end
      end
  end
end

class Refactored4 < ActionController::Base
  include Actions

  class << self
      def action_methods
        @action_methods ||= begin
                              methods = public_instance_methods(true)
                              internal_methods = internal_methods()
                              methods.reject! {|m| internal_methods.include?(m) }
                              methods.concat(public_instance_methods(false))
                              methods.map!(&:to_s)
                              methods.to_set
        end
      end
  end
end

Benchmark.memory do |x|
  x.report("original") do
    Current.clear_action_methods!
    Current.action_methods
  end

  x.report("refactored") do
    Refactored.clear_action_methods!
    Refactored.action_methods
  end

  x.report("refactored2") do
    Refactored2.clear_action_methods!
    Refactored2.action_methods
  end

  x.report("refactored3") do
    Refactored3.clear_action_methods!
    Refactored3.action_methods
  end

  x.report("refactored4") do
    Refactored4.clear_action_methods!
    Refactored4.action_methods
  end

  x.compare!
end

Benchmark.ips do |x|
  x.report("original") do
    Current.clear_action_methods!
    Current.action_methods
  end

  x.report("refactored") do
    Refactored.clear_action_methods!
    Refactored.action_methods
  end

  x.report("refactored2") do
    Refactored2.clear_action_methods!
    Refactored2.action_methods
  end

  x.report("refactored3") do
    Refactored3.clear_action_methods!
    Refactored3.action_methods
  end

  x.report("refactored4") do
    Refactored4.clear_action_methods!
    Refactored4.action_methods
  end

  x.compare! order: :baseline
end
