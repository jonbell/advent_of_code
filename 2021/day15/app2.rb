require '../../lib/common.rb'

require 'set'

Node = Struct.new(:x, :y, :danger)
INFINITY = 1 << 64

def read_lines(filename)
  File.readlines(filename).map(&:strip).map.with_index do |l, y|
    l.chars.map.with_index do |d, x|
      Node.new(x, y, d.to_i)
    end
  end
end

def increment(node, incr)
  value = node.danger
  incr.times do
    value += 1
    value = 1 if value > 9
  end
  value
end

def expand(graph)
  init_width = graph.first.size
  init_height = graph.size
  graph.map.with_index do |row, y|
    (1..4).each do |i|
      init_width.times do |j|
        x = i * init_width + j
        row << Node.new(x, y, increment(row[j], i))
      end
    end
  end

  (1..4).each do |i|
    init_height.times do |j|
      y = i * init_height + j
      graph << graph[j].map.with_index do |n, x|
        Node.new(x, y, increment(n, i))
      end
    end
  end
  graph
end

def neighbors(graph, node)
  [[1, 0], [0, 1], [0, -1], [-1, 0]].map do |iy, ix|
    ny = node.y + iy
    nx = node.x + ix
    graph[ny][nx] unless ny < 0 || nx < 0 || ny >= graph.size || nx >= graph[0].size
  end.compact
end

def solve(filename)
  graph = read_lines(filename)
  graph = expand(graph)

  first_position = graph[0][0]
  last_position = graph[graph.size-1][graph[0].size - 1]

  # Dijkstra's algorithm
  nodes = graph.flatten
  distances = { first_position => 0 }
  previous_nodes = {}
  until nodes.empty?
    # Very slow, should be using a priority queue
    nodes.sort_by! { |n| distances.key?(n) ? distances[n] : INFINITY }
    node = nodes.shift

    neighbors(graph, node).each do |neighbor|
      if !distances.key?(neighbor) || (distances[node] + neighbor.danger < distances[neighbor])
        distances[neighbor] = distances[node] + neighbor.danger
        previous_nodes[neighbor] = node
      end
    end
  end

  distances[last_position]
end

assert_equal(315, solve('test.txt'), 'Test result failed')

# Should be 2942
puts "Result: #{solve('input1.txt')}"
