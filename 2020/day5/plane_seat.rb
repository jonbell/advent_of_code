class PlaneSeat
  def self.parse_seats(filename)
    lines = File.readlines(File.join(File.dirname(__FILE__), filename))
    lines.map { |l| new(l) }
  end

  attr_reader :row, :column

  def initialize(text)
    @column = calc_number(text[0..6], 'F')
    @row = calc_number(text[7..9], 'L')
  end

  def id
    column * 8 + row
  end

  private

  def calc_number(text, low_char)
    low = 0
    high = 2 ** text.size - 1
    text.each_char do |l|
      if l == low_char
        high = (high - low) / 2 + low
      else
        low = (high - low) / 2 + low + 1
      end
    end
    low
  end
end