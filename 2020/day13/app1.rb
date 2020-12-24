def read_file(filename)
  timestamp, id_string = File.read(File.join(File.dirname(__FILE__), filename)).split("\n")
  ids = id_string.split(',').reject { |id| id == 'x' }.map(&:to_i)
  [timestamp.to_i, ids]
end

def solve(filename)
  timestamp, ids = read_file(filename)

  min_id = nil
  min_time = 99999999999
  ids.each do |id|
    time = ((timestamp / id) + 1) * id - timestamp
    if time < min_time
      min_time = time
      min_id = id
    end
  end

  min_id * min_time
end

sample_result = solve('sample.txt')
unless sample_result == 295
  puts "Sample result mismatch! expected 295, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"
