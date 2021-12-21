require '../../lib/common.rb'

class Dice
  attr_reader :rolled, :prev_roll

  def initialize
    @rolled = 0
    @prev_roll = 100
  end

  def roll
    @rolled += 1
    @prev_roll += 1
    @prev_roll = 1 if @prev_roll > 100
    @prev_roll
  end
end

def solve(p1, p2)
  dice = Dice.new

  p1_score = 0
  p2_score = 0
  loop do
    p1 = (p1 + dice.roll + dice.roll + dice.roll) % 10
    p1 = 10 if p1 == 0
    p1_score += p1
    return p2_score * dice.rolled if p1_score >= 1000

    p2 = (p2 + dice.roll + dice.roll + dice.roll) % 10
    p2 = 10 if p2 == 0
    p2_score += p2
    return p1_score * dice.rolled if p2_score >= 1000
  end
end

assert_equal(739785, solve(4, 8), 'Test result failed')

puts "Result: #{solve(1, 10)}"
