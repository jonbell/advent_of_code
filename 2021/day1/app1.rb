require '../../lib/common.rb'

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

assert_equal(7, calc_increases('test.txt'), 'Test result failed')

result = calc_increases('input1.txt')
puts "Received result: #{result}"
