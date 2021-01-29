module Promptable
  def prompt(message)
    puts "=> #{message}"
  end

  def clear_screen
    system("clear") || system("cls")
  end

  def rules
    <<~MSG
        ~~~~~~~~~~~~~~~~~~RULES~~~~~~~~~~~~~~~~~~
        Rock: crushes Lizard and crushes Scissors
        Paper: covers Rock and disproves Spock
        Scissors: cuts Paper and decapitates Lizard
        Lizard: poisons Spock and eats Paper
        Spock: smashes Scissors and vaporizes Rock
        (Enter: 'rules' if you need a reminder while playing)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        MSG
  end

  def invalid_choice
    prompt "Sorry, invalid choice"
  end

  def enter_to_continue
    loop do
      prompt 'Please press the enter key to continue to the next round...'
      action = gets
      break if action == "\n"
      prompt "Invalid key."
    end
    clear_screen
  end
end

class Move
  attr_reader :name, :beats

  include Comparable

  VALUES = ["rock", "paper", "scissors", "spock", "lizard",
            "r", "p", "sc", "l", "sp"]

  def to_s
    name.capitalize
  end

  def <=>(other_move)
    return 1 if beats.include?(other_move.name)
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
  attr_reader :move, :name
  attr_accessor :score

  def initialize
    set_name
    @score = 0
  end

  def choose(choice)
    self.move =
      case choice
      when "rock", "r" then Rock.new
      when "paper", "p" then Paper.new
      when "scissors", "sc" then Scissors.new
      when "lizard", "l" then Lizard.new
      when "spock", "sp" then Spock.new
      end
  end

  private

  attr_writer :move, :name
end

class Human < Player
  include Promptable

  def choose
    choice = nil
    loop do
      choice = determine_choice
      break if Move::VALUES.include?(choice)
      clear_screen
      choice == "rules" ? puts(rules) : invalid_choice
    end
    super(choice)
  end

  private

  def set_name
    name = ""
    clear_screen
    loop do
      prompt "What's your name?"
      name = gets.chomp
      break if name =~ /^[a-z]+$/i
      prompt "Sorry, must enter a valid name."
    end
    self.name = name
  end

  def determine_choice
    prompt "Please choose one: (r)ock, (p)aper, (sc)issors,"\
             " (l)izard or (sp)ock."
    gets.chomp.downcase
  end
end

class Computer < Player
  attr_reader :model, :strategy

  def initialize
    @robot = [R2D2, Hal, Chappie, Bender, XJ9].sample.new
    super
  end

  def set_name
    self.name = robot.model
  end

  def choose
    choice = robot.strategy.sample
    super(choice)
  end

  private

  attr_reader :robot
end

class R2D2 < Computer
  def initialize
    @model = "R2D2"
    @strategy = ["r"]
  end
end

class Hal < Computer
  def initialize
    @model = "Hal"
    @strategy = ["sc", "sc", "sc", "r"]
  end
end

class Chappie < Computer
  def initialize
    @model = "Chappie"
    @strategy = ["l", "l", "r", "p"]
  end
end

class Bender < Computer
  def initialize
    @model = "Bender"
    @strategy = ["r", "sc", "sp", "sp"]
  end
end

class XJ9 < Computer
  def initialize
    @model = "XJ9"
    @strategy = Move::VALUES
  end
end

class RPSGame
  include Promptable

  WINNING_SCORE = 3

  def initialize
    @human = Human.new
    @computer = Computer.new
    @move_history = []
  end

  def play
    display_welcome_message
    loop do
      round_loop
      display_final_winner
      reset_score
      reset_move_history
      break unless play_again?
      prompt "Who will win this time?"
    end
    display_goodbye_message
  end

  private

  attr_reader :human, :computer
  attr_accessor :move_history

  def display_welcome_message
    clear_screen
    puts <<~MSG
                Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!
                You are playing against #{computer.name}.
                First up to #{WINNING_SCORE} wins the game!
            MSG
    puts rules
  end

  def round_loop
    loop do
      human.choose
      computer.choose
      display_moves
      display_moves_history
      update_scores
      display_scores
      break if winner?
      enter_to_continue
    end
  end

  def display_goodbye_message
    prompt "Thanks for playing Rock, Paper, Scissors, Lizard, Spock." \
           " Goodbye #{human.name}!"
  end

  def display_moves
    clear_screen
    prompt "#{human.name} chose #{human.move} | " \
           "#{computer.name} chose #{computer.move} <="
    return if move_history.empty?
    puts "===============Game History================="
  end

  def display_winner(player)
    if player.class == Human
      "#{human.move} beats #{computer.move}. #{human.name} won!"
    elsif player.class == Computer
      "#{computer.move} beats #{human.move}. #{computer.name} won!"
    end
  end

  def round_result
    if human.move > computer.move
      display_winner(human)
    elsif human.move < computer.move
      display_winner(computer)
    else
      "You both chose #{human.move}. It's a tie!"
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

  def winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
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
    clear_screen
    answer == 'y'
  end

  def display_moves_history
    move_history << round_result
    move_history.each_with_index do |result, idx|
      if idx == move_history.size - 1
        puts "============================================"
        prompt "Current Round: #{result.upcase} <="
      else
        puts "Round #{idx + 1}: #{result}"
      end
    end
  end

  def reset_move_history
    self.move_history = []
  end
end

RPSGame.new.play
