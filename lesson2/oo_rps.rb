module Promptable

  def prompt(message)
    puts "=> #{message}"
  end

  def clear_screen
    system("clear") || system("cls")
  end

  def display_rules
    puts <<~MSG
        ~~~~~~~~~~~~~~~~~~RULES~~~~~~~~~~~~~~~~~~
        Rock: crushes Lizard and crushes Scissors
        Paper: covers Rock and vaporizes Rock
        Scissors: cuts Paper and decapitates Lizard
        Lizard: poisons Spock and eats Paper
        Spock: smashes Scissors and vaporizes Rock
        (Enter: 'rules' if you need a reminder while playing)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        MSG
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
  VALUES = ["rock", "paper", "scissors", "spock", "lizard", "r", "p", "sc", "l", "sp"]

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
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def choose(choice)
    self.move =
      case choice
      when "rock" , "r" then Rock.new
      when "paper", "p"  then Paper.new
      when "scissors", "sc"  then Scissors.new
      when "lizard", "l"  then Lizard.new
      when "spock", "sp"  then Spock.new
      end
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
      prompt "Please choose one: (r)ock, (p)aper, (sc)issors, (l)izard or (sp)ock."

      choice = gets.chomp.downcase
      if Move::VALUES.include?(choice)
        break
      elsif choice == "rules"
        clear_screen
        display_rules
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
  WINNING_SCORE = 3
  attr_accessor :human, :computer, :move_history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @move_history = []
  end

  def display_welcome_message
    puts <<~MSG
                Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!
                You are playing against #{computer.name}.
                First up to #{WINNING_SCORE} wins the game!
            MSG
  end

  def display_goodbye_message
    prompt "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye #{human.name}!"
  end

  def display_moves
    clear_screen
    prompt "#{human.name} chose #{human.move} | #{computer.name} chose #{computer.move} <="
    puts "======================================"
  end

  def display_winner
    if human.move > computer.move
      result = "#{human.move} beats #{computer.move}. #{human.name} won!"

    elsif human.move < computer.move
      result = "#{computer.move} beats #{human.move}. #{computer.name} won!"
    else
      result =  "You both chose #{human.move}. It's a tie!"
    end
    self.move_history << result
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
    move_history.each_with_index do |result, idx|
      if idx == move_history.size - 1
        prompt "Current Round: #{result}"
      else
        prompt "Round #{idx + 1}: #{result}"
      end
    end
  end

  def reset_move_history
    self.move_history = []
  end

  def play
    clear_screen
    display_welcome_message
    display_rules
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        display_moves_history
        update_scores
        display_scores
        break if human.score == WINNING_SCORE || computer.score == WINNING_SCORE
        enter_to_continue
      end
      display_final_winner
      reset_score
      reset_move_history
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play