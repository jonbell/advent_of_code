require '../../lib/common.rb'

class Entry
  attr_reader :signal, :output

  def initialize(str)
    signal, output = str.split('|')
    @signal = signal.strip.split(' ')
    @output = output.strip.split(' ')
  end
end

def read_entries(filename)
  File.readlines(filename).map { |line| Entry.new(line) }
end

def transcode(number_str)
  [2, 3, 4, 7].include?(number_str.size) ? 1 : 0
end

def solve(filename)
  read_entries(filename).map do |entry|
    entry.output.map { |s| transcode(s) }.sum
  end.sum
end


assert_equal(26, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
