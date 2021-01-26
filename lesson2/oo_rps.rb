module Promptable

  def prompt(message)
    puts "=> #{message}"
  end

  def clear_screen
    system("clear") || system("cls")
  end

  def rules
    <<~MSG
       RULES:
            Scissors cuts Paper covers Rock crushes Lizard poisons
            Spock smashes Scissors decapitates Lizard eats paper
            disproves Spock vaporizes Rock crushes Scissors.
            (Enter: 'rules' if you need a reminder while playing)
    MSG
  end

end

class Move
  attr_reader :name, :beats
  include Comparable
  VALUES = ["rock", "paper", "scissors", "spock", "lizard"]

  def to_s
    self.name.capitalize
  end

  def <=>(other_move)
     return 1 if self.beats.include?(other_move.name)
     return 0 if name == other_move.name
     -1
  end
end

class Rock < Move
  def initialize
    @name = "rock"
    @beats = ["scissors", "lizard"]
  end
end

class Paper < Move
  def initialize
    @name = "paper"
    @beats = ["rock", "spock"]
  end
end

class Scissors < Move
  def initialize
    @name = "scissors"
    @beats = ["paper", "lizard"]
  end
end

class Lizard < Move
  def initialize
    @name = "lizard"
    @beats = ["paper", "spock"]
  end
end

class Spock < Move
  def initialize
    @name = "spock"
    @beats = ["rock", "scissors"]
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    @score = 0
    @move_history = []
  end

  def choose(choice)
    self.move =
      case choice
      when "rock" then Rock.new
      when "paper" then Paper.new
      when "scissors" then Scissors.new
      when "lizard" then Lizard.new
      when "spock" then Spock.new
      end
    self.move_history << choice
  end

end

class Human < Player
  include Promptable
  def set_name
    name = ""
    loop do
      prompt "What's your name?"
      name = gets.chomp
      break unless name.empty?
      prompt "Sorry, must enter a value."
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      prompt "Please choose one: rock, paper, scissors, lizard or spock:"
      choice = gets.chomp.downcase
      if Move::VALUES.include?(choice)
        break
      elsif choice == "rules"
        clear_screen
        prompt(rules)
      else
        prompt "Sorry, invalid choice"
      end
    end
    super(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Chappie", "Bender", "XJ9"].sample
  end

  def choose
    choice = Move::VALUES.sample
    super(choice)
  end
end

class RPSGame
  include Promptable
  WINNING_SCORE = 5
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    prompt "Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    prompt "First up to #{WINNING_SCORE} wins the game."
  end

  def display_goodbye_message
    prompt "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye #{human.name}!"
  end

  def display_moves
    clear_screen
    prompt "#{human.name} chose #{human.move}."
    prompt "#{computer.name} chose #{computer.move}."
    puts "======================================"
  end

  def display_winner
    if human.move > computer.move
      prompt "#{human.move} beats #{computer.move}. #{human.name} won!"
    elsif human.move < computer.move
      prompt "#{computer.move} beats #{human.move}. #{computer.name} won!"
    else
      prompt "It's a tie!"
    end
  end

  def update_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def display_scores
    puts <<~MSG
                =>  ~~~~~~SCORE BOARD~~~~~~
                =>   #{human.name}: #{human.score}  | #{computer.name}: #{computer.score}
                =>  ~~~~~~~~~~~~~~~~~~~~~~~
            MSG
  end

  def display_final_winner
    if human.score == WINNING_SCORE
      prompt "Congrats #{human.name}, you are the grand winner!"
    else
      prompt "Sorry, #{computer.name} is the grand winner!"
    end
  end

  def play_again?
    answer = nil
    loop do
      prompt "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ["y", "n"].include?(answer)
      prompt "Sorry, must be y or n."
    end

    if answer.downcase == "n"
      false
    elsif answer.downcase == 'y'
      clear_screen
      prompt "Who will win this time?"
      true
    end
  end

  def display_moves_history
    prompt "Your moves: #{human.move_history}"
    prompt "#{computer.name}'s moves: #{computer.move_history}"
  end

  def reset_moves
    human.move_history = []
    computer.move_history = []
  end

  def play
    clear_screen
    display_welcome_message
    prompt(rules)
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        update_scores
        display_scores
        display_moves_history
        break if human.score == WINNING_SCORE || computer.score == WINNING_SCORE
      end
      display_final_winner
      reset_score
      reset_moves
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play