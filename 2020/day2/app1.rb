def check_min(min, char, password)
  password.count(char) >= min
end

def check_max(max, char, password)
  password.count(char) <= max
end

def validate(text)
  if text =~ /(\d+)-(\d+) ([a-z]): ([a-z]+)/
    min = $1.to_i
    max = $2.to_i
    char = $3
    password = $4

    return check_min(min, char, password) && check_max(max, char, password)
  end
  false
end

result = begin
  filename = File.join(File.dirname(__FILE__), 'input.txt')
  File.readlines(filename).select { |line| validate(line) }.size
end

puts "Found: #{result} valid passwords"
