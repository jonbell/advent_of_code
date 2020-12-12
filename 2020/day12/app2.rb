class Ship
  attr_reader :x, :y, :wx, :wy

  def initialize
    @x = 0
    @y = 0
    @wx = 10
    @wy = 1
  end

  def process(instruction)
    instruction =~ /^([NSEWLRF])(\d+)$/
    action = $1
    value = $2.to_i

    case action
    when 'N'
      @wy += value
    when 'S'
      @wy -= value
    when 'E'
      @wx += value
    when 'W'
      @wx -= value
    when 'R'
      (value / 90).times do
        @wx, @wy = [wy, -wx]
      end
    when 'L'
      (value / 90).times do
        @wx, @wy = [-wy, wx]
      end
    when 'F'
      @x += wx * value
      @y += wy * value
    end
  end
end

def read_file(filename)
  File.read(File.join(File.dirname(__FILE__), filename)).split("\n")
end

def solve(filename)
  ship = Ship.new
  read_file(filename).each do |inst|
    ship.process(inst)
  end
  ship.x.abs + ship.y.abs
end

sample_result = solve('sample.txt')
unless sample_result == 286
  puts "Sample result mismatch! expected 286, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"
