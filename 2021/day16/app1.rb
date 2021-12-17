require '../../lib/common.rb'

TYPE_LITERAL = 4

Packet = Struct.new(:version, :type_id, :literal, :sub_packets)

def read_transmission(filename)
  t = File.readlines(filename).first.strip.to_i(16).to_s(2)
  while (t.size % 4) != 0
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

def count_versions(packet)
  packet.version + packet.sub_packets.map { |p| count_versions(p) }.sum
end

def solve(filename)
  transmission = read_transmission(filename)

  packet = parse_packet(transmission)[1]

  count_versions(packet)
end

assert_equal(16, solve('test1.txt'), 'Test 1 result failed')
assert_equal(12, solve('test2.txt'), 'Test 2 result failed')
assert_equal(23, solve('test3.txt'), 'Test 3 result failed')
assert_equal(31, solve('test4.txt'), 'Test 4 result failed')

puts "Result: #{solve('input1.txt')}"
