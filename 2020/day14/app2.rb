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

def each_mem(mask, value, &block)
  results = [0]
  (mask.size - 1).downto(0) do |i|
    if mask[i] == 'X'
      results = results.flat_map do |result|
        [result, (result + (1 << i))]
      end
    else
      results.map! do |result|
        result + ((mask[i].to_i << i) | (value[i].to_i << i))
      end
    end
  end
  results.each(&block)
end

def solve(filename)
  register = {}
  instructions(filename) do |mask, mem, value|
    each_mem(mask, mem) do |actual_mem|
      register[actual_mem] = value
    end
  end
  register.values.sum
end

sample_result = solve('sample2.txt')
unless sample_result == 208
  puts "Sample result mismatch! expected 208, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"
