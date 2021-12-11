require '../../lib/common.rb'

class Octopus
  attr_reader :row, :col, :energy

  def initialize(row, col, energy)
    @row = row
    @col = col
    @energy = energy
  end

  def increment!
    @energy += 1
  end

  def flashing?
    @energy > 9
  end

  def reset!
    @energy = 0 if flashing?
  end
end

class Grid
  def initialize(filename)
    @octopuses = File.readlines(filename).map(&:strip).map.with_index do |l, r|
      l.split('').map.with_index do |e, c|
        Octopus.new(r, c, e.to_i)
      end
    end

    @row_size = @octopuses.size
    @col_size = @octopuses.first.size
  end

  def all
    @octopuses.flatten
  end

  def increment_all!
    all.each { |o| o.increment! }
  end

  def reset_all!
    all.each { |o| o.reset! }
  end

  def flashing!
    flashed = []

    all.each do |oct|
      check_flashing(oct, flashed)
    end

    flashed
  end

  def inspect
    @octopuses.map { |r| r.map { |o| o.energy.to_s }.join }.join("\n")
  end

  private
  def check_flashing(oct, flashed)
    return if !oct.flashing? || flashed.include?(oct)
    flashed << oct

    (-1..1).each do |r|
      nrow = oct.row + r
      next if nrow < 0 || nrow >= @row_size
      (-1..1).each do |c|
        next if r == 0 and c == 0
        ncol = oct.col + c
        next if ncol < 0 || ncol >= @col_size

        noct = @octopuses[nrow][ncol]
        noct.increment!
        check_flashing(noct, flashed)
      end
    end
  end
end

def solve(filename)
  grid = Grid.new(filename)

  flashes = 0
  100.times do |i|
    grid.increment_all!
    flashed = grid.flashing!
    flashes += flashed.size
    grid.reset_all!
  end
  flashes
end

assert_equal(1656, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
