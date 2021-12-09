require '../../lib/common.rb'

Point = Struct.new(:row_num,:col_num, :height) do
end

DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def low_points(height_map)
  low_points = []
  rows = height_map[:rows]
  rows_size = height_map[:rows_size]
  cols_size = height_map[:cols_size]
  
  rows.each do |row|
    row.each do |point|
      row_num = point.row_num
      col_num = point.col_num
      height = point.height
      if ((row_num == 0) || (rows[row_num - 1][col_num].height > height)) &&
         ((row_num + 1 == rows_size) || (rows[row_num + 1][col_num].height > height)) &&
         ((col_num == 0) || (rows[row_num][col_num - 1].height > height)) &&
         ((col_num + 1 == cols_size) || (rows[row_num][col_num + 1].height > height))
        
        low_points << point
      end   
    end
  end
  low_points
end

def valid_point?(row_num, col_num, rows_size, cols_size)
  row_num >= 0 &&
  row_num < rows_size &&
  col_num >= 0 &&
  col_num < cols_size
end

def build_basin(height_map, basin, point)
  rows = height_map[:rows]
  rows_size = height_map[:rows_size]
  cols_size = height_map[:cols_size]
  DIRECTIONS.each do |dir|
    n_row_num = point.row_num + dir[0]
    n_col_num = point.col_num + dir[1]

    if valid_point?(n_row_num, n_col_num, rows_size, cols_size)
      n_point = rows[n_row_num][n_col_num]
      if n_point.height != 9 && !basin.include?(n_point) && n_point.height > point.height
        basin << n_point
        build_basin(height_map, basin, n_point)
      end
    end
  end
  basin
end

def solve(filename)
  rows = File.readlines(filename).map(&:strip).map.with_index do |l, r|
    l.split('').map(&:to_i).map.with_index do |h, c|
      Point.new(r, c, h)
    end
  end

  height_map = { rows: rows, rows_size: rows.size, cols_size: rows.first.size }

  lps = low_points(height_map)
  basins = lps.map do |low_point|
    basin = build_basin(height_map, [low_point], low_point)
  end

  basins.map(&:size).sort.reverse[0..2].inject(&:*)
end

assert_equal(1134, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
