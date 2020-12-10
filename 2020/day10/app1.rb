def read_numbers(filename)
  [0] + File.readlines(File.join(File.dirname(__FILE__), filename)).map { |l| l.to_i }
end

def solve(filename)
  numbers = read_numbers(filename).sort
  numbers
  result = [0, 0, 1]
  numbers[1..].each_with_index do |n, i|
    result[n - numbers[i] - 1] += 1
  end
  result[0] * result[2]
end

sample_result = solve('sample1.txt')
unless sample_result == 35
  puts "Sample result 1 mismatch! expected 35, got #{sample_result}"
  exit 1
end

sample_result = solve('sample2.txt')
unless sample_result == 220
  puts "Sample result 2 mismatch! expected 220, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"

