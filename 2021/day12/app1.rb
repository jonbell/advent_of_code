require '../../lib/common.rb'
require 'set'

class Node
  attr_reader :name, :vertices

  def initialize(name)
    @name = name
    @vertices = Set.new
  end

  def connect(other)
    @vertices << other
  end

  def small?
    name =~ /[a-z]+/
  end

  def inspect
    @name
  end
end

class Graph
  def initialize(filename)
    @nodeMap = {}
    File.readlines(filename).map(&:strip).map { |s| s.split('-') }.each do |names|
      anode, bnode = names.map do |name|
        if @nodeMap.include?(name)
          @nodeMap[name]
        else
          node = Node.new(name)
          @start = node if name == 'start'
          @end = node if name == 'end'
          @nodeMap[name] = node
          node
        end
      end
      anode.connect(bnode)
      bnode.connect(anode)
    end
  end

  def all_paths(node = @start, prev_path = [])
    return [] if node.small? && prev_path.include?(node)

    prev_path << node
    return [prev_path] if node == @end

    result = []
    node.vertices.each do |nnode|
      paths = all_paths(nnode, prev_path.dup)
      result += paths unless paths.empty?
    end
    result
  end
end

def solve(filename)
  Graph.new(filename).all_paths.size
end

assert_equal(10, solve('test1.txt'), 'Test 1 failed')
assert_equal(19, solve('test2.txt'), 'Test 2 failed')
assert_equal(226, solve('test3.txt'), 'Test 3 failed')

puts "Result: #{solve('input1.txt')}"
