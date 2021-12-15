require '../../lib/common.rb'

Node = Struct.new(:x, :y, :danger)

def read_lines(filename)
  File.readlines(filename).map(&:strip).map.with_index do |l, y|
    l.chars.map.with_index do |d, x|
      Node.new(x, y, d.to_i)
    end
  end
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
  first_position = graph[0][0]
  last_position = graph[graph.size-1][graph[0].size - 1]

  # Dijkstra's algorithm
  nodes = graph.flatten
  distances = { first_position => 0 }
  previous_nodes = {}
  until nodes.empty?
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

assert_equal(40, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
