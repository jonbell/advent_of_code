require '../../lib/common.rb'

class Board
  class Cell
    attr_reader :value
    attr_accessor :selected

    def initialize(value)
      @value = value
      @selected = false
    end
  end

  def initialize(lines)
    @rows = []
    lines.each do |line|
      @rows << line.split(/\s+/).map { |c| Cell.new(c.to_i) }
    end
  end

  def call(draw)
    @rows.each do |r|
      r.each_with_index do |c, j|
        if c.value == draw
          c.selected = true
          return true if check_row_for_win(r) || check_column_for_win(j)
        end
      end
    end
    false
  end

  def sum_unmarked
    acc = 0
    @rows.each do |row|
      row.each do |c|
        acc += c.value unless c.selected
      end
    end
    acc
  end

  def inspect
    @rows.map { |row| row.map { |c| (c.selected ? '*' : '') + c.value.to_s }.join(", ") }.join("\n")
  end

  private
  def check_row_for_win(row)
    row.all? { |c| c.selected }
  end

  def check_column_for_win(j)
    @rows.all? { |row| row[j].selected }
  end
end

class Game
  def initialize(filename)
    lines = File.readlines(filename).map { |l| l.strip }

    @draws = lines[0].split(',').map(&:to_i)
    @boards = []

    (2..(lines.size - 1)).step(6) do |i|
      @boards << Board.new(lines[i..(i+4)])
    end
  end

  def inspect
    "Draws: #{@draws}\n\nBoards:\n#{@boards.map { |b| b.inspect}.join("\n\n")}"
  end

  def solve
    @draws.each do |d|
      @boards.each do |b|
        bingo = b.call(d)
        if bingo
          @boards = @boards.reject { |b2| b == b2 }
          return d * b.sum_unmarked if @boards.empty?
        end
      end
    end
  end
end

def solve(filename)
  Game.new(filename).solve
end

assert_equal(1924, solve('test.txt'))

result = solve('input1.txt')
puts "Result is: #{result}"
