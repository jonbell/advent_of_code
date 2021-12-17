require '../../lib/common.rb'

TYPE_SUM = 0
TYPE_PRODUCT = 1
TYPE_MIN = 2
TYPE_MAX = 3
TYPE_LITERAL = 4
TYPE_GREATER_THAN = 5
TYPE_LESS_THAN = 6
TYPE_EQUAL = 7

Packet = Struct.new(:version, :type_id, :literal, :sub_packets)

def read_transmission(filename)
  line = File.readlines(filename).first.strip
  t = line.to_i(16).to_s(2)
  while (t.size != (line.size * 4))
    t = '0' + t
  end
  t
end

def read_bits(str, num)
  [str[num..], str[0..(num-1)].to_i(2)]
end

def read_literal(str)
  lit_str = ''
  loop do
    part = str[0..4]
    str = str[5..]
    lit_str += part[1..]
    break if part[0] == '0'
  end
  [str, lit_str.to_i(2)]
end

def parse_packet(str)
  str, version = read_bits(str, 3)
  str, type_id = read_bits(str, 3)

  literal = nil
  sub_packets = []

  if type_id == TYPE_LITERAL
    str, literal = read_literal(str)
  else
    str, length_type_id = read_bits(str, 1)
    if length_type_id == 0
      str, length = read_bits(str, 15)
      
      sub_packets_str = str[0..(length-1)]
      str = str[length..]

      while sub_packets_str.size > 4
        sub_packets_str, sub_packet = parse_packet(sub_packets_str)
        sub_packets << sub_packet
      end
    else
      str, num_sub_packets = read_bits(str, 11)
      num_sub_packets.times do
        str, sub_packet = parse_packet(str)
        sub_packets << sub_packet
      end
    end
  end

  [str, Packet.new(version, type_id, literal, sub_packets)]
end

def calc_packet(packet)
  sub_packets = packet.sub_packets.map { |p| calc_packet(p) }
  if packet.type_id == TYPE_SUM
    sub_packets.sum
  elsif packet.type_id == TYPE_PRODUCT
    sub_packets.inject(&:*)
  elsif packet.type_id == TYPE_MIN
    sub_packets.min
  elsif packet.type_id == TYPE_MAX
    sub_packets.max
  elsif packet.type_id == TYPE_LITERAL
    packet.literal
  elsif packet.type_id == TYPE_GREATER_THAN
    sub_packets[0] > sub_packets[1] ? 1 : 0
  elsif packet.type_id == TYPE_LESS_THAN
    sub_packets[0] < sub_packets[1] ? 1 : 0
  elsif packet.type_id == TYPE_EQUAL
    sub_packets[0] == sub_packets[1] ? 1 : 0
  end
end

def solve(filename)
  transmission = read_transmission(filename)

  packet = parse_packet(transmission)[1]

  calc_packet(packet)
end

assert_equal(3, solve('test21.txt'), 'Test 1 result failed')
assert_equal(54, solve('test22.txt'), 'Test 2 result failed')
assert_equal(7, solve('test23.txt'), 'Test 3 result failed')
assert_equal(9, solve('test24.txt'), 'Test 4 result failed')
assert_equal(1, solve('test25.txt'), 'Test 5 result failed')
assert_equal(0, solve('test26.txt'), 'Test 6 result failed')
assert_equal(0, solve('test27.txt'), 'Test 7 result failed')
assert_equal(1, solve('test28.txt'), 'Test 8 result failed')

puts "Result: #{solve('input1.txt')}"
