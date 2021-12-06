require '../../lib/common.rb'

Line = Struct.new(:x1, :y1, :x2, :y2) do
  def vertical?
    self.x1 == self.x2
  end

  def horizontal?
    self.y1 == self.y2
  end

  def diagonal?
    (self.x1 - self.x2).abs == (self.y1 - self.y2).abs
  end

  def range_x
    if self.x1 > self.x2
      (self.x2)..(self.x1)
    else
      (self.x1)..(self.x2)
    end
  end

  def range_y
    if self.y1 > self.y2
      (self.y2)..(self.y1)
    else
      (self.y1)..(self.y2)
    end
  end

  def range_diag(&block)
    dir_x = self.x1 < self.x2 ? 1 : -1
    dir_y = self.y1 < self.y2 ? 1 : -1
    x = self.x1
    y = self.y1

    loop do
      yield [x, y]

      break if x == self.x2

      x += dir_x
      y += dir_y
    end
  end
end

def parse_struct(line)
  line =~ /(\d+),(\d+) -> (\d+),(\d+)/
  Line.new($1.to_i, $2.to_i, $3.to_i, $4.to_i)
end

def read_lines(filename)
  File.readlines(filename).map { |l| parse_struct(l) }
end

def print_grid(grid)
  size_x = grid.keys.max_by { |p| p[0] }[0]
  size_y = grid.keys.max_by { |p| p[1] }[1]

  puts [size_x, size_y].inspect

  0.upto(size_y) do |y|
    0.upto(size_x) do |x|
      if grid.key?([x, y])
        print grid[[x, y]]
      else
        print '.'
      end
    end
    puts
  end
end

def solve(filename)
  lines = read_lines(filename)
  grid = lines.each_with_object({}) do |line, grid|
    if line.horizontal?
      line.range_x.each do |x|
        point = [x, line.y1]
        if grid.key?(point)
          grid[point] += 1
        else
          grid[point] = 1
        end
      end
    elsif line.vertical?
      line.range_y.each do |y|
        point = [line.x1, y]
        if grid.key?(point)
          grid[point] += 1
        else
          grid[point] = 1
        end
      end
    elsif line.diagonal?
      line.range_diag do |point|
        if grid.key?(point)
          grid[point] += 1
        else
          grid[point] = 1
        end
      end
    end
  end

  grid.values.select { |v| v > 1 }.size
end

assert_equal(12, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
