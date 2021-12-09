require '../../lib/common.rb'

def risk(point)
  point + 1
end

def solve(filename)
  low_points = []
  rows = File.readlines(filename).map(&:strip).map { |l| l.split('').map(&:to_i) }
  rows_size = rows.size
  cols_size = rows.first.size
  rows.each_with_index do |row, row_num|
    row.each_with_index do |height, col_num|
      if ((row_num == 0) || (rows[row_num - 1][col_num] > height)) &&
         ((row_num + 1 == rows_size) || (rows[row_num + 1][col_num] > height)) &&
         ((col_num == 0) || (rows[row_num][col_num - 1] > height)) &&
         ((col_num + 1 == cols_size) || (rows[row_num][col_num + 1] > height))
        
        low_points << height
      end   
    end
  end
  low_points.map { |p| risk(p) }.sum
end

assert_equal(15, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
