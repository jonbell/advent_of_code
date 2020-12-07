require_relative 'node_parser.rb'

def bag_can_contain?(registry, bag, target_color)
  bag.contents.any? do |arc|
    arc.color == target_color || bag_can_contain?(registry, registry[arc.color], target_color)
  end
end

def count_all_children(registry, bag)
  bag.contents.map do |arc|
    arc.count + arc.count * count_all_children(registry, registry[arc.color])
  end.sum
end

def count_for_color(filename, color)
  registry = NodeParser.new(filename).registry
  count_all_children(registry, registry[color])
end

sample_result = count_for_color('sample.txt', 'shiny gold')
unless sample_result == 32
  puts "Sample result mismatch! expected 32, got #{sample_result}"
  exit 1
end

puts "Answer is #{count_for_color('input.txt', 'shiny gold')}"
