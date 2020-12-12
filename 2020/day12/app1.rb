class Ship
  attr_reader :x, :y, :facing

  def initialize
    @x = 0
    @y = 0
    @facing = 0
  end

  def process(instruction)
    instruction =~ /^([NSEWLRF])(\d+)$/
    action = $1
    value = $2.to_i

    case action
    when 'N'
      @y += value
    when 'S'
      @y -= value
    when 'E'
      @x += value
    when 'W'
      @x -= value
    when 'R'
      @facing -= value
    when 'L'
      @facing += value
    when 'F'
      case @facing % 360
      when 0
        @x += value
      when 90
        @y += value
      when 180
        @x -= value
      when 270
        @y -= value
      else
        puts "UNKNOWN FACING: #{value}"
      end
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
unless sample_result == 25
  puts "Sample result mismatch! expected 25, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"
