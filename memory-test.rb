key = "foo bar"
puts key.object_id

# downcased = key.downcase
# puts downcased.object_id
#
# to_sd = downcased.to_s
# puts to_sd.object_id

upper_regex = /[A-Z]/
("a".."z").each do |letter|
  puts "#{letter}: #{letter.match?(upper_regex)}"
end
