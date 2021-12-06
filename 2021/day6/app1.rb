require '../../lib/common.rb'

def read_fish(filename)
  fish = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  states = File.readlines(filename).first.strip.split(',').map(&:to_i)
  states.each do |state|
    fish[state] += 1
  end
  fish
end

def solve(filename)
  fish = read_fish(filename)
  80.times do
    new_fish = fish.shift
    fish[8] = new_fish
    fish[6] += new_fish
  end
  fish.sum
end

assert_equal(5934, solve('test.txt'))

puts "Result is: #{solve('input1.txt')}"
