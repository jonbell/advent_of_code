require '../../lib/common.rb'
require 'set'

Point = Struct.new(:x, :y)
Fold = Struct.new(:axis, :position)

def read_points_and_folds(filename)
  lines = File.readlines(filename).map(&:strip)
  points = Set.new
  folds = []
  reading_points = true
  lines.each do |line|
    if line.empty?
      reading_points = false
      next
    end

    if reading_points
      points << Point.new(*line.split(',').map(&:to_i))
    else
      line =~ /fold along ([xy])=(\d+)/
      folds << Fold.new($1, $2.to_i)
    end
  end
  [points, folds]
end

def fold(points, fold)
  if fold.axis == 'y'
    points.map do |point|
      max_fold = points.map { |p| p.y }.max - fold.position
      if point.y == fold.position
        nil
      elsif point.y > fold.position
        newy = max_fold - (point.y - fold.position)
        Point.new(point.x, newy)
      else
        point
      end
    end.compact.to_set
  else
    points.map do |point|
      max_fold = points.map { |p| p.x }.max - fold.position
      if point.x == fold.position
        nil
      elsif point.x > fold.position
        newx = max_fold - (point.x - fold.position)
        Point.new(newx, point.y)
      else
        point
      end
    end.compact.to_set
  end
end

def print_grid(points)
  max_x = points.map { |p| p.x }.max
  max_y = points.map { |p| p.y }.max
  (0..max_y).each do |y|
    (0..max_x).each do |x|
      print points.include?(Point.new(x, y)) ? '#' : ' '
    end
    puts
  end
end

def solve(filename)
  points, folds = read_points_and_folds(filename)
  
  folds.each do |fold|
    points = fold(points, fold)
  end

  print_grid(points)
end

puts 'Test:'
solve('test.txt')
puts 'Input:'
solve('input1.txt')

