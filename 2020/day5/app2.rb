require_relative 'plane_seat.rb'

seat_ids = PlaneSeat.parse_seats('input.txt').map(&:id)

max_seat = 8 * 127 - 1

missing_seats = []
8.upto max_seat do |seat|
  missing_seats << seat unless seat_ids.include?(seat)
end

my_seat = missing_seats.detect do |seat|
  !missing_seats.include?(seat-1) || !missing_seats.include?(seat+1)
end

puts "My seat is: #{my_seat}"
