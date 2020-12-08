require_relative 'machine.rb'

class Compiler
  attr_reader :machine

  def initialize(filename)
    @machine = Machine.new
    File.readlines(File.join(File.dirname(__FILE__), filename)).each do |line|
      if line =~ /^(nop|acc|jmp) ([+-]\d+)$/
        machine.add($1.to_sym, $2.to_i)
      end
    end
  end
end
