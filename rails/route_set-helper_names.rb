require 'benchmark/ips'
require 'benchmark/memory'

# require 'action_dispatch'
# require 'action_dispatch/routing/route_set'

class NamedRouteCollection
  def initialize
    @path_helpers = Set.new
    @url_helpers = Set.new
    @helper_names = Set.new
  end

  def add(name)
    path_name = :"#{name}_path"
    url_name  = :"#{name}_url"
    @path_helpers << path_name
    @url_helpers << url_name
  end

  def add_refactored(name)
    path_name = :"#{name}_path"
    url_name  = :"#{name}_url"
    @path_helpers << path_name
    @url_helpers << url_name
    @helper_names << path_name.to_s << url_name.to_s
  end

  def helper_names
    @path_helpers.map(&:to_s) + @url_helpers.map(&:to_s)
  end

  def refactored_helper_names
    names = @path_helpers.map(&:to_s)
    names.concat(@url_helpers.map(&:to_s))
  end

  def refactored2_helper_names
    @path_helpers.merge(@url_helpers).map!(&:to_s)
  end

  def refactored3_helper_names
    @helper_names
  end
end

puts "==MEMORY"
Benchmark.memory do |x|
  x.report("original") do
    collection = NamedRouteCollection.new
    collection.add('users')
    collection.add('new_user')
    collection.add('destroy_user')
    collection.add('user')

    collection.helper_names
    collection.helper_names
    collection.helper_names
  end

  x.report("refactored") do
    collection = NamedRouteCollection.new
    collection.add('users')
    collection.add('new_user')
    collection.add('destroy_user')
    collection.add('user')

    collection.refactored_helper_names
    collection.refactored_helper_names
    collection.refactored_helper_names
  end

  x.report("refactored2") do
    collection = NamedRouteCollection.new
    collection.add('users')
    collection.add('new_user')
    collection.add('destroy_user')
    collection.add('user')

    collection.refactored2_helper_names
    collection.refactored2_helper_names
    collection.refactored2_helper_names
  end

  x.report("refactored3") do
    collection = NamedRouteCollection.new
    collection.add_refactored('users')
    collection.add_refactored('new_user')
    collection.add_refactored('destroy_user')
    collection.add_refactored('user')

    collection.refactored3_helper_names
    collection.refactored3_helper_names
    collection.refactored3_helper_names
  end

  x.compare!
end

puts "==IPS"
Benchmark.ips do |x|
  x.report("original") do
    collection = NamedRouteCollection.new
    collection.add('users')
    collection.add('new_user')
    collection.add('destroy_user')
    collection.add('user')

    collection.helper_names
    collection.helper_names
    collection.helper_names
  end

  x.report("refactored") do
    collection = NamedRouteCollection.new
    collection.add('users')
    collection.add('new_user')
    collection.add('destroy_user')
    collection.add('user')

    collection.refactored_helper_names
    collection.refactored_helper_names
    collection.refactored_helper_names
  end

  x.report("refactored2") do
    collection = NamedRouteCollection.new
    collection.add('users')
    collection.add('new_user')
    collection.add('destroy_user')
    collection.add('user')

    collection.refactored2_helper_names
    collection.refactored2_helper_names
    collection.refactored2_helper_names
  end

  x.report("refactored3") do
    collection = NamedRouteCollection.new
    collection.add_refactored('users')
    collection.add_refactored('new_user')
    collection.add_refactored('destroy_user')
    collection.add_refactored('user')

    collection.refactored3_helper_names
    collection.refactored3_helper_names
    collection.refactored3_helper_names
  end

  x.compare! order: :baseline
end
