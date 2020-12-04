class Map
  attr_reader :frame
  attr_reader :position
  def initialize(text)
    @frame = text.split("\n")
    @position = [0, 0]
  end

  def move(x, y)
    @position = [@position[0] + x, @position[1] + y]
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

x, y = [3, 1]
trees = 0
until map.finished? do
  trees += 1 if map.at_tree?
  map.move(x, y)
end

puts "Completed, encountered #{trees} trees"
