class Passport
  attr_reader :birth_year, :issue_year, :expiration_year, :height,
              :hair_color, :eye_color, :passport_id, :country_id

  def initialize(fields)
    @birth_year = fields['byr']
    @issue_year = fields['iyr']
    @expiration_year = fields['eyr']
    @height = fields['hgt']
    @hair_color = fields['hcl']
    @eye_color = fields['ecl']
    @passport_id = fields['pid']
    @country_id = fields['cid']
  end

  def valid?
    !birth_year.nil? &&
      !issue_year.nil? &&
      !expiration_year.nil? &&
      !height.nil? &&
      !hair_color.nil? &&
      !eye_color.nil? &&
      !passport_id.nil?
  end

  def extended_valid?
    valid? &&
      birth_year_valid? &&
      issue_year_valid? &&
      expiration_year_valid? &&
      height_valid? &&
      hair_color_valid? &&
      eye_color_valid? &&
      passport_id_valid?
  end

  def validate_number(text, num_digits, min, max)
    if Regexp.new("^\\d{#{num_digits}}$") =~ text
      number = text.to_i
      return number >= min && number <= max
    end
    false
  end

  def birth_year_valid?
    validate_number(birth_year, 4, 1920, 2002)
  end

  def issue_year_valid?
    validate_number(issue_year, 4, 2010, 2020)
  end

  def expiration_year_valid?
    validate_number(expiration_year, 4, 2020, 2030)
  end

  def height_valid?
    if height =~ /^(\d+)cm$/
      h = $1.to_i
      return h >= 150 && h <= 193
    elsif height =~ /^(\d+)in$/
      h = $1.to_i
      return h >= 59 && h <= 76
    end
    false
  end

  def hair_color_valid?
    hair_color =~ /^#[0-9a-z]{6}$/
  end

  def eye_color_valid?
    %w{amb blu brn gry grn hzl oth}.include?(eye_color)
  end

  def passport_id_valid?
    passport_id =~ /^\d{9}$/
  end
end