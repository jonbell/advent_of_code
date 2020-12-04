numbers = begin
  filename = File.join(File.dirname(__FILE__), 'input.txt')
  File.readlines(filename).map(&:to_i)
end

numbers.each_with_index do |x, i|
  y = numbers[(i+1)..].detect do |y|
    x + y == 2020
  end

  if y
    result = x * y
    puts "Found: #{x} * #{y} = #{result}"
    break
  end
end
