def read_numbers(filename)
  [0] + File.readlines(File.join(File.dirname(__FILE__), filename)).map(&:to_i)
end

def count_paths(numbers, idx, cache)
  return cache[idx] if cache[idx]
  paths = 0
  j = idx + 1
  max_jolt = numbers[idx] + 3
  while max_jolt >= numbers[j] do
    if j == numbers.size - 1
      paths += 1
      break
    else
      paths += count_paths(numbers, j, cache)
      j += 1
    end
  end
  cache[idx] = paths
end

def solve(filename)
  numbers = read_numbers(filename).sort
  count_paths(numbers, 0, [])
end

sample_result = solve('sample1.txt')
unless sample_result == 8
  puts "Sample result 1 mismatch! expected 8, got #{sample_result}"
  exit 1
end

sample_result = solve('sample2.txt')
unless sample_result == 19208
  puts "Sample result 2 mismatch! expected 19208, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"

