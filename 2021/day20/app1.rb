require '../../lib/common.rb'

def read_lines(filename)
  File.readlines(filename).map(&:strip)
end

def parse(lines)
  algo = lines[0].chars.map { |c| c == '.' ? 0 : 1 }

  image = lines[2..].map { |l| l.chars.map { |c| c == '.' ? 0 : 1 } }

  [algo, image]
end

def next_default_value(algo, default_value)
  default_value == 0 ? algo.first : algo.last
end

def apply_algo(algo, image, default_value)
  max_y = image.size
  max_x = image.first.size

  new_image = []
  (-1..(image.size)).each do |y|
    row = []
    (-1..image.first.size).each do |x|
      num = 0
      (-1..1).each do |yi|
        (-1..1).each do |xi|
          num <<= 1
          xp = x + xi
          yp = y + yi

          value = yp >= 0 && yp < max_y && xp >= 0 && xp < max_x ? image[yp][xp] : default_value
          num += value
        end
      end

      row << algo[num]
    end
    new_image << row
  end
  [new_image, next_default_value(algo, default_value)]
end

def print_image(image)
  image.each do |row|
    row.each do |c|
      print c == 1 ? '#' : '.'
    end
    puts
  end
  puts
end

def solve(lines)
  algo, image = parse(lines)
  default_value = 0

  2.times do
    image, default_value = apply_algo(algo, image, default_value)
  end
  image.map { |l| l.sum }.sum
end

def solve_for_file(filename)
  solve(read_lines(filename))
end

assert_equal(35, solve_for_file('test.txt'), 'Test result failed')

puts "Result: #{solve_for_file('input1.txt')}"
