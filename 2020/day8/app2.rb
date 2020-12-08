require_relative 'compiler.rb'

def compile_and_execute(filename)
  machine = Compiler.new(filename).machine
  
  machine.mutations.detect do |m|
    m.execute
    m.completed?
  end.accumulator
end

sample_result = compile_and_execute('sample.txt')
unless sample_result == 8
  puts "Sample result mismatch! expected 8, got #{sample_result}"
  exit 1
end

puts "Answer is #{compile_and_execute('input.txt')}"
