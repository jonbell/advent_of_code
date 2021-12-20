require '../../lib/common.rb'

require 'json'

class Node
  attr_accessor :parent, :l, :r

  def initialize(parent, l, r)
    @parent = parent
    @l = l
    @r = r
  end

  def +(o)
    raise "Can only add top-level #{self} + #{o}" unless parent.nil? && o.parent.nil?
    n = Node.new(nil, self, o)
    self.parent = n
    o.parent = n
    n
  end

  def magnitude
    l = @l.is_a?(Integer) ? @l : @l.magnitude
    r = @r.is_a?(Integer) ? @r : @r.magnitude
    (3 * l) + (2 * r)
  end

  def inspect
    "[#{self.l.inspect},#{self.r.inspect}]"
  end
end

def parse_node(line, parent = nil)
  n = Node.new(parent, nil, nil)
  if line[0].is_a?(Integer)
    n.l = line[0]
  else
    n.l = parse_node(line[0], n)
  end

  if line[1].is_a?(Integer)
    n.r = line[1]
  else
    n.r = parse_node(line[1], n)
  end
  n
end

def print_graph(node)
  until node.parent.nil?
    node = node.parent
  end
  puts node.inspect
end

def find_next_left_pair(node)
  n = node

  while n != nil && n.parent&.r != n
    n = n.parent
  end
  n = n&.parent

  return nil unless n

  return ['l', n] if n.l.is_a?(Integer)
  n = n.l
  until n.r.is_a?(Integer)
    n = n.r
  end

  ['r', n]
end

def find_next_right_pair(node)
  n = node

  while n != nil && n.parent&.l != n
    n = n.parent
  end
  n = n&.parent

  return nil unless n

  return ['r', n] if n.r.is_a?(Integer)
  n = n.r
  until n.l.is_a?(Integer)
    n = n.l
  end

  ['l', n]
end

def explode!(node)
  result = find_next_left_pair(node)
  if result
    dir, rnode = result
    if dir == 'l'
      rnode.l += node.l
    else
      rnode.r += node.l
    end
  end

  result = find_next_right_pair(node)
  if result
    dir, rnode = result
    if dir == 'l'
      rnode.l += node.r
    else
      rnode.r += node.r
    end
  end

  parent = node.parent
  if parent
    if parent.l == node
      parent.l = 0
    else
      parent.r = 0
    end
  end
end

def split(parent, num)
  Node.new(parent, num / 2, num / 2 + num % 2)
end

def scan_explode!(node, depth = 1)
  if depth == 5
    explode!(node)
    return true
  end

  (!node.l.is_a?(Integer) && scan_explode!(node.l, depth + 1)) ||
    (!node.r.is_a?(Integer) && scan_explode!(node.r, depth + 1))
end

def scan_split!(node)
  if node.l.is_a?(Integer)
    if node.l > 9
      node.l = split(node, node.l)
      return true
    end
  else
    result = scan_split!(node.l)
    return true if result
  end

  if node.r.is_a?(Integer)
    if node.r > 9
      node.r = split(node, node.r)
      return true
    end
  else
    return scan_split!(node.r)
  end
  false
end

def add!(x, y)
  node = (x + y)
  loop do
    break unless scan_explode!(node) || scan_split!(node)
  end
  node
end

def solve(lines)
  graphs = lines.map { |s| parse_node(JSON.parse(s)) }

  snode = nil
  graphs.each do |n|
    snode = snode.nil? ? n : add!(snode, n)
  end
  
  snode.magnitude
end

def solve_from_file(filename)
  solve(File.readlines(filename).map(&:strip))
end

assert_equal(4140, solve_from_file('test1.txt'), 'Test result failed')

puts "Result: #{solve_from_file('input1.txt')}"
