def read_depth(filename)
  File.readlines(filename).map { |l| l.to_i }
end

def calc_increases(filename)
  last = nil
  increases = 0
  read_depth(filename).each do |depth|
    increases += 1 if last && last < depth
    last = depth
  end
  increases
end

test_result = calc_increases('test.txt')
unless test_result == 7
  puts "Test result failed, expected 7 received: #{test_result}"
  exit 1
end

result = calc_increases('input1.txt')
puts "Received result: #{result}"
