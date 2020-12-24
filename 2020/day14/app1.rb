def instructions(filename, &block)
  mask = nil
  File.read(File.join(File.dirname(__FILE__), filename)).split("\n").each do |line|
    if line =~ /^mask = ([X10]{36})$/
      mask = $1.reverse
    elsif line =~ /^mem\[(\d+)\] = (\d+)$/
      yield mask, $1.to_i, $2.to_i
    else
      puts "ERROR unmatched input: #{line}"
    end
  end
end

def apply_mask(mask, value)
  result = 0
  (mask.size - 1).downto(0) do |i|
    if mask[i] == 'X'
      result += (value[i] << i)
    else
      result += (mask[i].to_i << i)
    end
  end
  result
end

def solve(filename)
  register = {}
  instructions(filename) do |mask, mem, value|
    register[mem] = apply_mask(mask, value)
  end
  register.values.sum
end

sample_result = solve('sample.txt')
unless sample_result == 165
  puts "Sample result mismatch! expected 165, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"
