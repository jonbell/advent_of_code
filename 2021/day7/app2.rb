require '../../lib/common.rb'

def read_crabs(filename)
  File.readlines(filename).first.strip.split(',').map(&:to_i)
end

$fuel_dist_cache = {}
def fuel_for_distance(distance)
  return $fuel_dist_cache[distance] if $fuel_dist_cache.key?(distance)
  result = 0
  distance.times do |i|
    result += 1 + i
  end
  $fuel_dist_cache[distance] = result
  result
end

def calculate_fuel(crabs, position)
  crabs.map do |crab|
    fuel_for_distance((crab - position).abs)
  end.sum
end

def solve(filename)
  crabs = read_crabs(filename)
  min_fuel = nil
  ((crabs.min)..(crabs.max)).select do |position|
    fuel = calculate_fuel(crabs, position)
    min_fuel = fuel if min_fuel.nil? || min_fuel > fuel
  end
  min_fuel
end

assert_equal(168, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
