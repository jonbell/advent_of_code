require '../../lib/common.rb'

def read_lines(filename)
  File.readlines(filename)
end

def parse(line)
  if line =~ /forward (\d+)/
    [$1.to_i, 0]
  elsif line =~ /down (\d+)/
    [0, $1.to_i]
  elsif line =~ /up (\d+)/
    [0, -($1.to_i)]
  end
end

def move(filename)
  x = 0
  y = 0
  moves = read_lines(filename).map { |l| parse(l) }
  moves.each do |dx, dy|
    x += dx
    y += dy
  end
  x * y
end

assert_equal(150, move('test.txt'))

result = move('input.txt')
puts "Result is #{result}"
