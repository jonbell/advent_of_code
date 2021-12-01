def read_depth(filename)
  File.readlines(filename).map { |l| l.to_i }
end

def sliding_windows(filename, &block)
  last = nil
  last2 = nil
  read_depth(filename).each do |depth|
    yield last + last2 + depth if last && last2
    last2 = last
    last = depth
  end
end

def calc_increases(filename)
  last = nil
  increases = 0
  sliding_windows(filename) do |depth|
    increases += 1 if last && last < depth
    last = depth
  end
  increases
end

test_result = calc_increases('test.txt')
unless test_result == 5
  puts "Test result failed, expected 5 received: #{test_result}"
  exit 1
end

result = calc_increases('input1.txt')
puts "Received result: #{result}"
