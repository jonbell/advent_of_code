SAMPLE = [0,3,6]
INPUT = [19,20,14,0,9,1]
# STOP_AT = 2020
STOP_AT = 30_000_000

def solve(arr)
  last_num = arr.last
  registry = {}
  arr.each_with_index do |v, i|
    registry[v] = i + 1
  end
  (arr.size + 1).upto(STOP_AT) do |current_step|
    prev_step = registry[last_num]
    registry[last_num] = current_step - 1
    if prev_step
      last_num = current_step - prev_step - 1
    else
      last_num = 0
    end
  end
  last_num
end

sample_result = solve(SAMPLE)
unless sample_result == 175594
  puts "Sample result mismatch! expected 175594, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve(INPUT)}"

