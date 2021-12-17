require '../../lib/common.rb'

def parse_target_area(str)
  str =~ /target area: x=([\-0-9]+)\.\.([\-0-9]+), y=([\-0-9]+)\.\.([\-0-9]+)/
  [($1.to_i)..($2.to_i), ($3.to_i)..($4.to_i)]
end

def calc_valid_x(target_area)
  x = 0
  valid_x = []
  loop do
    x += 1

    break if x > target_area[0].last

    xp = 0
    x.downto(0) do |vx|
      xp += vx

      if target_area[0].include?(xp)
        valid_x << x
        break
      end
    end
  end
  valid_x
end

def all_velocity_for_x(target_area, x)
  all_v = []
  1000.downto(-1000) do |y|
    vx = x
    vy = y
    
    px = 0
    py = 0
    lmax_y = 0

    while vx > 0 || py > target_area[1].min
      px += vx
      py += vy

      vx -= 1 if vx > 0
      vy -= 1

      lmax_y = py if py > lmax_y

      if target_area[0].include?(px) && target_area[1].include?(py)
        all_v << [x, y]
        break
      end
    end
  end

  all_v
end

def all_velocity(target_area, all_x)
  all_v = all_x.map { |x| all_velocity_for_x(target_area, x)}
  all_v.inject(&:+)
end

def solve(target_str)
  target_area = parse_target_area(target_str)

  valid_x = calc_valid_x(target_area)

  all_v = all_velocity(target_area, valid_x)
  all_v.size
end

assert_equal(112, solve('target area: x=20..30, y=-10..-5'))

puts "Result is: #{solve('target area: x=79..137, y=-176..-117')}"
