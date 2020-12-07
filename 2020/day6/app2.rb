def parse_num_letters(filename)
  text = File.read(File.join(File.dirname(__FILE__), filename))

  groups = text.split("\n\n")

  num_letters = 0
  groups.each do |group|
    group_answers = group.split("\n")
    if group_answers.size == 1
      num_letters += group_answers[0].size
    else
      group_answers[0].each_char do |l|
        num_letters += 1 if group_answers[1..].all? { |ga| ga.include?(l) }
      end
    end
  end
  num_letters
end

sample_result = parse_num_letters('sample.txt')
unless sample_result == 6
  puts "Sample result mismatch! expected 6, got #{sample_result}"
  exit 1
end

puts "Answer is #{parse_num_letters('input.txt')}"
