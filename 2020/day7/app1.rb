require_relative 'node_parser.rb'

def bag_can_contain?(registry, bag, target_color)
  bag.contents.any? do |arc|
    arc.color == target_color || bag_can_contain?(registry, registry[arc.color], target_color)
  end
end

def search_for_parents_of_color(registry, target_color)
  registry.values.select do |bag|
    bag.color != target_color && bag_can_contain?(registry, bag, target_color)
  end
end

def count_for_color(filename, color)
  registry = NodeParser.new(filename).registry
  search_for_parents_of_color(registry, color).size
end

sample_result = count_for_color('sample.txt', 'shiny gold')
unless sample_result == 4
  puts "Sample result mismatch! expected 4, got #{sample_result}"
  exit 1
end

puts "Answer is #{count_for_color('input.txt', 'shiny gold')}"
