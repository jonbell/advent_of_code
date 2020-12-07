class Node
  attr_reader :color, :contents

  def initialize(color)
    @color = color
    @contents = []
  end
end
Arc = Struct.new(:color, :count)

class NodeParser
  attr_reader :registry

  def initialize(filename)
    @registry = {}

    File.readlines(File.join(File.dirname(__FILE__), filename)).each do |line|
      line =~ /^([a-z ]+) bags contain (.+)/
      color = $1
      tail = $2

      bag = Node.new(color)
      @registry[color] = bag

      while /(\d)+ ([a-z ]+) bags?(.*)/ =~ tail do
        bag.contents << Arc.new($2, $1.to_i)
        tail = $3
      end
    end
  end
end
