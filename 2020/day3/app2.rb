class Map
  attr_reader :frame
  attr_reader :position
  def initialize(text)
    @frame = text.split("\n")
    @position = [0, 0]
  end

  def count_trees(velocity)
    @position = [0, 0]
    trees = 0
    until finished? do
      trees += 1 if at_tree?
      move(velocity)
    end
    trees
  end

  def move(velocity)
    @position = [@position[0] + velocity[0], @position[1] + velocity[1]]
  end

  def finished?
    position[1] >= frame.size
  end

  def at_tree?
    line = frame[position[1]]
    x = position[0] % line.size
    line[x] == '#'
  end
end

map = begin
  filename = File.join(File.dirname(__FILE__), 'input.txt')
  Map.new(File.read(filename))
end

velocities = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]
result = 1
velocities.each { |v| result = result * map.count_trees(v) }

puts result
