class InvalidToken < StandardError; end

class Minilang
  attr_accessor :register, :stack

  COMMANDS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(commands)
    @commands = commands.split
    @register = 0
    @stack = []
  end

  def eval
    @commands.each do |command|
      if command =~ /[0-9]/
        self.register = command.to_i
      else
        raise InvalidToken, "Invalid token: #{command}" unless COMMANDS.include?(command)
        self.send command.downcase.to_sym
      end
    end
  end

  def print
    puts register
  end

  def push
    stack << register
  end

  def mult
    self.register *= stack.pop
  end

  def add
    self.register += stack.pop
  end

  def pop
    raise StandardError, "Empty Stack!" if stack.empty?
    self.register = stack.shift
  end

  def div
    self.register /= stack.pop
  end

  def mod
    self.register %= stack.pop
  end

  def sub
    self.register -= stack.pop
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)