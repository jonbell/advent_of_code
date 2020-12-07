require 'set'

def parse_num_letters(filename)
  text = File.read(File.join(File.dirname(__FILE__), filename))

  groups = text.split("\n\n")

  num_letters = 0
  groups.each do |group|
    s = Set.new
    group.each_char do |l|
      next if l == "\n"
      s << l
    end
    num_letters += s.size
  end
  num_letters
end

sample_result = parse_num_letters('sample.txt')
unless sample_result == 11
  puts "Sample result mismatch! expected 11, got #{sample_result}"
  exit 1
end

puts "Answer is #{parse_num_letters('input.txt')}"
