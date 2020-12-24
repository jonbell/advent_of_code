def read_file(filename)
  id_string = File.read(File.join(File.dirname(__FILE__), filename)).split("\n")[1]
  id_string.split(',').map { |s| s == 'x' ? 'x' : s.to_i }
end

def solve(filename)
  ids = read_file(filename)

  lcm = 1
  time = 0
  prev_id = nil
  ids.each_with_index do |id, idx|
    next if id == 'x'
    lcm *= prev_id if prev_id
    while (time + idx) % id != 0 do
      time += lcm
    end
    prev_id = id
  end
  time
end

sample_result = solve('sample.txt')
unless sample_result == 1068781
  puts "Sample result mismatch! expected 1068781, got #{sample_result}"
  exit 1
end

puts 'Sample test successful'

puts "Answer is #{solve('input.txt')}"
