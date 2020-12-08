class Machine
  Operation =  Struct.new(:operand, :value, :calls)

  attr_reader :operations, :current_line, :accumulator
  attr_accessor 

  def initialize
    @operations = []
    @accumulator = 0
    @current_line = 0
  end

  def mutations
    copies = []
    operations.each_with_index do |op, index|
      if op.operand == :jmp
        copy = Machine.new
        clone_operations(copy)
        copy.operations[index] = Operation.new(:nop, op.value, 0)
        copies << copy
      elsif op.operand == :nop
        copy = Machine.new
        clone_operations(copy)
        copy.operations[index] = Operation.new(:jmp, op.value, 0)
        copies << copy
      end
    end
    copies
  end

  def add(op, value)
    operations << Operation.new(op, value, 0)
  end

  def execute
    loop do
      op = operations[current_line]
      break if op.nil? || op.calls > 0
      
      send(op.operand, op.value)
      op.calls += 1
    end
  end

  def completed?
    current_line >= operations.size
  end

  private

  def acc(value)
    @accumulator += value
    @current_line += 1
  end

  def nop(_)
    @current_line += 1
  end

  def jmp(value)
    @current_line += value
  end

  def clone_operations(copy)
    operations.each do |op|
      copy.add(op.operand, op.value)
    end
  end
end
