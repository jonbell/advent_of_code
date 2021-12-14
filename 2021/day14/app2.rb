require '../../lib/common.rb'

def read_lines(filename)
  File.readlines(filename).map(&:strip)
end

def add_pair(template, pair, count = 1)
  if template.key?(pair)
    template[pair] += count
  else
    template[pair] = count
  end
end

def read_template_and_insertion_rules(filename)
  lines = read_lines(filename)
  template = lines[0]

  template = (1..(template.size-1)).each_with_object({}) do |i, acc|
    add_pair(acc, template[((i-1)..i)])
  end

  rules = lines[2..-1].map do |line|
    line.split(' -> ')
  end.to_h
  [template, rules]
end

def apply_rules(template, rules)
  ntemplate = {}
  template.each do |pair, count|
    insertion = rules[pair]
    if insertion
      add_pair(ntemplate, pair[0] + insertion, count)
      add_pair(ntemplate, insertion + pair[1], count)
    else
      add_pair(ntemplate, pair, count)
    end
  end
  ntemplate
end

def most_sub_least_common(template)
  counts = { template.keys[0][0] => 1 }
  template.each do |pair, count|
    c = pair[1]
    if counts.key?(c)
      counts[c] += count
    else
      counts[c] = count
    end
  end

  counts = counts.values
  counts.max - counts.min
end

def solve(filename)
  template, rules = read_template_and_insertion_rules(filename)

  40.times do
    template = apply_rules(template, rules)
  end
  most_sub_least_common(template)
end

assert_equal(2188189693529, solve('test.txt'), 'Test result failed')

puts "Result: #{solve('input1.txt')}"
