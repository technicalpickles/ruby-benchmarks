args = [1, 2, 3]

def splat(*args)
  puts "inside args.object_id: #{args.object_id}"
  puts "before after modification: #{args.inspect}"
  args << 4
  puts "inside after modification: #{args.inspect}"
end

puts "args.object_id: #{args.object_id}"
puts "before: #{args.inspect}"
splat(*args)
puts "after: #{args.inspect}"
