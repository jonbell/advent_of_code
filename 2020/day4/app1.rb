require_relative('./passport_parser.rb')

def calculate_result(filename)
  passports = PassportParser.new(filename).passports
  passports.select { |p| p.valid? }.size
end

sample_result = calculate_result('sample.txt')
if sample_result == 2
  input_result = calculate_result('input.txt')
  puts "Result: #{input_result}"
else
  puts "Test failed! #{sample_result} != 2"
end
