require '../../lib/common.rb'

def read_file(filename)
  File.readlines(filename).map { |l| l.strip }
end

def filter_lines_to_int(filename, &block)
  lines = read_file(filename)
  size = lines.first.size
  0.upto(size - 1) do |i|
    zeroes = 0
    ones = 0
    lines.each do |l|
      if l[i] == '1'
        ones += 1
      else
        zeroes += 1
      end
    end

    match_char = yield [ones, zeroes]

    lines.select! { |l| l[i] == match_char }

    if lines.size == 1
      return lines.first.to_i(2)
    end
  end
end

def oxygen_generator(filename)
  filter_lines_to_int(filename) { |ones, zeroes| ones >= zeroes ? '1' : '0' }
end

def co2_scrubber(filename)
  filter_lines_to_int(filename) { |ones, zeroes| ones >= zeroes ? '0' : '1' }
end

def life_support_rating(filename)
  oxygen_generator(filename) * co2_scrubber(filename)
end

assert_equal(230, life_support_rating('test.txt'))

result = life_support_rating('input1.txt')
puts "The result is #{result}"
