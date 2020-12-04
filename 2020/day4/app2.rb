require_relative('./passport_parser.rb')

def calculate_result(filename)
  passports = PassportParser.new(filename).passports
  passports.select { |p| p.extended_valid? }.size
end

input_result = calculate_result('input.txt')
puts "Result: #{input_result}"
