require '../../lib/common.rb'

GameState = Struct.new(:p1, :p2, :p1_score, :p2_score, :turn)

POSSIBLE_ROLLS = [1, 2, 3].product([1, 2, 3], [1, 2, 3]).map(&:sum)

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

def search(state, memo = {})
  return memo[state] if memo.key?(state)

  if state.p1_score >= 21
    return [1, 0]
  elsif state.p2_score >= 21
    return [0, 1]
  end

  wins = POSSIBLE_ROLLS.map do |roll|
    p1 = state.p1
    p1_score = state.p1_score
    p2 = state.p2
    p2_score = state.p2_score
    next_turn = -1
    if state.turn == 0
      p1 = (p1 + roll) % 10
      p1 = 10 if p1 == 0
      p1_score += p1
      next_turn = 1
    else
      p2 = (p2 + roll) % 10
      p2 = 10 if p2 == 0
      p2_score += p2
      next_turn = 0
    end
    new_state = GameState.new(p1, p2, p1_score, p2_score, next_turn)
    search(new_state, memo)
  end

  memo[state] = wins.transpose.map(&:sum)
end

def solve(p1, p2)
  search(GameState.new(p1, p2, 0, 0, 0)).max
end

assert_equal(444356092776315, solve(4, 8), 'Test result failed')

puts "Result: #{solve(1, 10)}"
