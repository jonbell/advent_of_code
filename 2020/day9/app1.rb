def read_numbers(filename)
  File.readlines(File.join(File.dirname(__FILE__), filename)).map { |l| l.to_i }
end

def any_matches?(target, seq, pre)
  seq.any? do |s|
    pre + s == target
  end
end

def first_invalid(numbers, preamble)
  invalid_idx = (preamble..(numbers.size - 1)).detect do |i|
    target = numbers[i]
    seq = numbers[(i-preamble), preamble]
    result = false
    seq.each_with_index do |x, j|
      if any_matches?(target, seq[(j+1)..], x)
        result = true
        break
      end
    end
    !result
  end
  numbers[invalid_idx]
end

def find_first_invalid(filename, preamble = 25)
  numbers = read_numbers(filename)
  first_invalid(numbers, preamble)
end

sample_result = find_first_invalid('sample.txt', 5)
unless sample_result == 127
  puts "Sample result mismatch! expected 127, got #{sample_result}"
  exit 1
end

puts "Answer is #{find_first_invalid('input.txt')}"
