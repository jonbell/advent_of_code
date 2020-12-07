require_relative 'plane_seat.rb'

def assert_seat(seat, expected)
  raise "Assertion failure: seat: #{seat.inspect} not expected ID: #{expected}" unless seat.id == expected
end

sample_seats = PlaneSeat.parse_seats('sample.txt')
assert_seat sample_seats[0], 357
assert_seat sample_seats[1], 567
assert_seat sample_seats[2], 119
assert_seat sample_seats[3], 820

puts "Max seat: #{PlaneSeat.parse_seats('input.txt').map(&:id).max}"
