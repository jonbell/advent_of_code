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

def solve(filename)
  points, folds = read_points_and_folds(filename)
  
  fold(points, folds.first).size
end

assert_equal(17, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
