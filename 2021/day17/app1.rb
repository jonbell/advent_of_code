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

def calc_max_y_for_x(target_area, x)
  max_y = nil
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
        max_y = lmax_y if max_y.nil? || lmax_y > max_y
        break
      end
    end
  end

  max_y
end

def calc_max_y(target_area, all_x)
  all_x.map { |x| calc_max_y_for_x(target_area, x)}.compact.max
end

def solve(target_str)
  target_area = parse_target_area(target_str)

  valid_x = calc_valid_x(target_area)

  calc_max_y(target_area, valid_x)
end

assert_equal(45, solve('target area: x=20..30, y=-10..-5'))

puts "Result is: #{solve('target area: x=79..137, y=-176..-117')}"
