SAMPLE = [0,3,6]
INPUT = [19,20,14,0,9,1]

def lindex(arr, value)
  ridx = arr.reverse.index(value)
  return nil unless ridx
  arr.size - ridx - 1
end

def solve(arr)
  results = arr.dup
  results.size.upto(2019) do |i|
    idx = lindex(results[0..-2], results[i-1])
    results[i] = idx.nil? ? 0 : (i - idx - 1)
  end
  results.last
end

sample_result = solve(SAMPLE)
unless sample_result == 436
  puts "Sample result mismatch! expected 295, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve(INPUT)}"

