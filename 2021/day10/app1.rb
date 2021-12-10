require '../../lib/common.rb'

def read_lines(filename)
  File.readlines(filename).map(&:strip).map { |s| s.split('') }
end

PAIRS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}

SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

def illegal_char(str)
  stack = []
  str.each do |c|
    if PAIRS.include?(c)
      if stack.last == PAIRS[c]
        stack = stack[0..-2]
      else
        return c
      end
    elsif PAIRS.values.include?(c)
      stack << c
    end
  end
  nil
end

def solve(filename)
  read_lines(filename).map { |l| illegal_char(l) }.compact.map { |c| SCORES[c] }.sum
end

assert_equal(26397, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
