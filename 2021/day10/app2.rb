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
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

def incomplete_line(str)
  stack = []
  str.each do |c|
    if PAIRS.include?(c)
      if stack.last == PAIRS[c]
        stack = stack[0..-2]
      else
        stack = []
        break
      end
    elsif PAIRS.values.include?(c)
      stack << c
    end
  end
  stack
end

def score(stack)
  stack = stack.map { |c| SCORES[c] }.reverse
  score = 0
  stack.each do |s|
    score = score * 5 + s
  end
  score
end

def solve(filename)
  scores = read_lines(filename).map { |l| incomplete_line(l) }.reject(&:empty?).map { |chars| score(chars) }
  scores.sort[scores.size / 2]
end

assert_equal(288957, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
