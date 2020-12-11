def read_file(filename)
  File.read(File.join(File.dirname(__FILE__), filename)).split("\n")
end

def lookup_seat(map, x, y)
  map[y][x]
end

def first_seat_in_dir(map, x, y, x_dir, y_dir)
  loop do
    x += x_dir
    y += y_dir
    break if x < 0 || y < 0 || x >= map[0].size || y >= map.size

    seat = lookup_seat(map, x, y)
    return seat if seat != '.'
  end
  '.'
end

def occupied_visibile_seats(map, x, y)
  count = 0
  (-1..1).each do |x_dir|
    (-1..1).each do |y_dir|
      next if x_dir == 0 && y_dir == 0
      
      count += 1if first_seat_in_dir(map, x, y, x_dir, y_dir) == '#'
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
        occupied_visibile_seats(map, x, y) == 0 ? '#' : 'L'
      when '#'
        occupied_visibile_seats(map, x, y) >= 5 ? 'L' : '#'
      when '.'
        '.'
      end
    # puts "x: #{x}, y: #{y} #{seat} changed to: #{next_map[y][x]}"
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
    # puts map.join("\n") + "\n"*2 + '*'*10 + "\n"*2
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
unless sample_result == 26
  puts "Sample result mismatch! expected 26, got #{sample_result}"
  exit 1
end

puts "Answer is #{solve('input.txt')}"
