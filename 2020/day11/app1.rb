def read_file(filename)
  File.read(File.join(File.dirname(__FILE__), filename)).split("\n")
end

def lookup_seat(map, x, y)
  map[y][x]
end

def occupied_adjacent_seats(map, x, y)
  count = 0
  ((x-1)..(x+1)).each do |xi|
    next if xi < 0 || xi >= map[0].size
    ((y-1)..(y+1)).each do |yi|
      next if yi < 0 || yi >= map.size || (xi == x && yi == y)
      count += 1 if lookup_seat(map, xi, yi) == '#'
    end
  end
  count
end

def each_seat(map, &block)
  cols = map.size
  rows = map[0].size
  (0..(map[0].size - 1)).each do |x|
    (0..(map.size - 1)).each do |y|
      yield lookup_seat(map, x, y), x, y
    end
  end
end

def dup_map(map)
  new_map = map.map { |r| r.dup }
end

def update_map(map)
  next_map = dup_map(map)
  cols = map.size
  rows = map[0].size
  each_seat(map) do |seat, x, y|
    next_map[y][x] = 
      case seat
      when 'L'
        occupied_adjacent_seats(map, x, y) == 0 ? '#' : 'L'
      when '#'
        occupied_adjacent_seats(map, x, y) >= 4 ? 'L' : '#'
      when '.'
        '.'
      end
  end
  next_map
end

def count_occupied_seats(map)
  count = 0
  each_seat(map) do |seat|
    count += 1 if seat == '#'
  end
  count
end

def find_stable(map)
  prev_map = nil
  while map != prev_map
    prev_map = map
    map = update_map(map)
  end
  map
end

def solve(filename)
  map = read_file(filename)
  map = find_stable(map)
  count_occupied_seats(map)
end

sample_result = solve('sample.txt')
unless sample_result == 37
  puts "Sample result mismatch! expected 37, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"

