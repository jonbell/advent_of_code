require '../../lib/common.rb'

def read_file(filename)
  File.readlines(filename).map { |l| l.strip }
end

def power_consumption(filename)
  lines = read_file(filename)
  epsilon = 0
  gamma = 0
  0.upto(lines.first.size - 1) do |i|
    zeroes = 0
    ones = 0
    lines.each do |l|
      if l[i].to_i == 1
        ones += 1
      else
        zeroes += 1
      end
    end

    epsilon = epsilon << 1
    gamma = gamma << 1
    if ones > zeroes
      gamma += 1
    else
      epsilon += 1
    end
  end

  gamma * epsilon
end

assert_equal(198, power_consumption('test.txt'))

result = power_consumption('input1.txt')
puts "The result is #{result}"
