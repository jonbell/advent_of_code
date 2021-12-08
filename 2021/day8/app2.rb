require '../../lib/common.rb'

class Transcoder
  ALL_LETTERS = [:a, :b, :c, :d, :e, :f, :g]

  NUMBER_GRAPH = {
    0 => [:a, :b, :c, :e, :f, :g],
    1 => [:c, :f],
    2 => [:a, :c, :d, :e, :g],
    3 => [:a, :c, :d, :f, :g],
    4 => [:b, :c, :d, :f],
    5 => [:a, :b, :d, :f, :g],
    6 => [:a, :b, :d, :e, :f, :g],
    7 => [:a, :c, :f],
    8 => [:a, :b, :c, :d, :e, :f, :g],
    9 => [:a, :b, :c, :d, :f, :g]
  }

  #
  # 5 size: 2 unique e , 3, 5
  # 6 size: 0, 6, 9

  def initialize
    @digits_read = []
    @mappings = {
      a: ALL_LETTERS.dup,
      b: ALL_LETTERS.dup,
      c: ALL_LETTERS.dup,
      d: ALL_LETTERS.dup,
      e: ALL_LETTERS.dup,
      f: ALL_LETTERS.dup,
      g: ALL_LETTERS.dup,
    }

    @number_mappings = {}
  end

  def solved?
    @mappings.values.all? { |possible| possible.size == 1 }
  end

  def analyze!(entry)
    return if @digits_read.include?(entry)

    if entry.size == 2
      reduce_mapping(NUMBER_GRAPH[1], entry)
      set_number(1, entry)
    elsif entry.size == 3
      reduce_mapping(NUMBER_GRAPH[7], entry)
      set_number(7, entry)
    elsif entry.size == 4
      reduce_mapping(NUMBER_GRAPH[4], entry)
      set_number(4, entry)
    elsif entry.size == 7
      set_number(8, entry)
    end
    @digits_read << entry
  end

  def digits_5
    @digits_read.select { |d| d.size == 5 }
  end

  def solve_for_2!
    digits = digits_5
    e_digits = @mappings[:e]
    e = e_digits.detect do |ed|
      !digits.all? { |d| d.include?(ed) }
    end
    reduce_mapping([:e], [e])
    numb2 = digits.detect do |d|
      d.include?(e)
    end
    set_number(2, numb2)
  end

  def solve_for_3_and_5!
    digits = digits_5
    c_digits = @mappings[:c]
    numb2 = @number_mappings[2]
    c = c_digits.detect do |cd|
      numb2.include?(cd.to_s)
    end
    reduce_mapping([:c], [c])
    reduce_mapping([:f], c_digits - [c])
    numb3 = digits.detect do |d|
      d.join != numb2 && d.include?(c)
    end
    set_number(3, numb3)
    numb5 = digits.detect do |d|
      ![@number_mappings[2], @number_mappings[3]].include?(d.join)
    end
    set_number(5, numb5)

    b = @mappings[:b].detect do |bd|
      !numb2.include?(bd.to_s) && !numb3.include?(bd)
    end
    reduce_mapping([:b], [b])
  end

  def solve_for_rest!
    set_number(0, translate_number(0))
    set_number(6, translate_number(6))
    set_number(8, translate_number(8))
    set_number(9, translate_number(9))
  end

  def solve!
    solve_for_2!
    solve_for_3_and_5!
    solve_for_rest!
  end

  def translate(entry)
    str = entry.sort.join
    @number_mappings.detect { |numb, encoded| str == encoded }[0]
  end

  def inspect
    "Mappings: #{@mappings.inspect}\nNumbers: #{@number_mappings.inspect}"
  end

  private
  def reduce_mapping(letters, possible_values)
    letters.each do |letter|
      @mappings[letter] &= possible_values
    end

    (ALL_LETTERS - letters).each do |letter|
      @mappings[letter] -= possible_values
    end
  end

  def set_number(numb, entry)
    @number_mappings[numb] = entry.sort.join
  end

  def translate_number(number)
    letters = NUMBER_GRAPH[number]
    letters.map do |l|
      @mappings[l].first
    end
  end
end

class Entry
  attr_reader :signal, :output

  def initialize(str)
    signal, output = str.split('|')
    @signal = signal.strip.split(' ').map { |s| s.scan(/\w/).map(&:to_sym).sort}
    @output = output.strip.split(' ').map { |s| s.scan(/\w/).map(&:to_sym).sort}
  end
end

def read_entries(filename)
  File.readlines(filename).map { |line| Entry.new(line) }
end

def solve(filename)
  read_entries(filename).map do |entry|
    t = Transcoder.new
    (entry.signal + entry.output).each { |e| t.analyze!(e) }
    t.solve!
    entry.output.map { |e| t.translate(e).to_s }.join.to_i
  end.sum
end

assert_equal(61229, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
