require '../../lib/common.rb'

def read_lines(filename)
  File.readlines(filename).map(&:strip)
end

def read_template_and_insertion_rules(filename)
  lines = read_lines(filename)
  template = lines[0]
  rules = lines[2..-1].map do |line|
    line.split(' -> ')
  end.to_h
  [template, rules]
end

def apply_rules(template, rules)
  ntemplate = template[0]
  (1..(template.size-1)).each do |i|
    segment = template[((i-1)..i)]
    insertion = rules[segment]
    ntemplate << insertion if insertion
    ntemplate << template[i]
  end
  ntemplate
end

def most_sub_least_common(template)
  counts = template.split('').each_with_object({}) do |c, acc|
    if acc.key?(c)
      acc[c] += 1
    else
      acc[c] = 1
    end
    acc
  end.values

  counts.max - counts.min
end

def solve(filename)
  template, rules = read_template_and_insertion_rules(filename)
  
  10.times do
    template = apply_rules(template, rules)
  end
  most_sub_least_common(template)
end

assert_equal(1588, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
