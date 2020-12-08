require_relative 'compiler.rb'

def compile_and_execute(filename)
  machine = Compiler.new(filename).machine
  machine.execute
  machine.accumulator
end

sample_result = compile_and_execute('sample.txt')
unless sample_result == 5
  puts "Sample result mismatch! expected 5, got #{sample_result}"
  exit 1
end

puts "Answer is #{compile_and_execute('input.txt')}"
