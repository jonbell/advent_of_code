numbers = begin
  filename = File.join(File.dirname(__FILE__), 'input.txt')
  File.readlines(filename).map(&:to_i)
end

def find_yz(numbers, x, offset)
  numbers[(offset+1)..].each_with_index do |y, j|
    z = numbers[(offset+j+2)..].detect do |z|
      x + y + z == 2020
    end

    return [y, z] if z
  end
  nil
end

numbers.each_with_index do |x, i|
  found = find_yz(numbers, x, i)

  if found
    y, z = found
    result = x * y *z
    puts "Found: #{x} * #{y} * #{z}= #{result}"
    break
  end
end
