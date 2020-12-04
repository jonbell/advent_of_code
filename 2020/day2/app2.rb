def check_pos(pos, char, password)
  password[pos - 1] == char
end

def validate(text)
  if text =~ /(\d+)-(\d+) ([a-z]): ([a-z]+)/
    pos1 = $1.to_i
    pos2 = $2.to_i
    char = $3
    password = $4

    return check_pos(pos1, char, password) ^ check_pos(pos2, char, password)
  end
  false
end

result = begin
  filename = File.join(File.dirname(__FILE__), 'input.txt')
  File.readlines(filename).select { |line| validate(line) }.size
end

puts "Found: #{result} valid passwords"
