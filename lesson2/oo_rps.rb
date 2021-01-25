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
  def set_name
    name = ""
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, must enter a value."
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or spock:"
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice"
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
  WINNING_SCORE = 5
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Hi #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye #{human.name}!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      human.score += 1
      puts "#{human.name} won!"
    elsif human.move < computer.move
      computer.score += 1
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def display_scores
    puts "#{human.name}: #{human.score} points | " +
         "#{computer.name}: #{computer.score} points"
  end

  def display_final_winner
    if human.score == WINNING_SCORE
      puts "Congrats #{human.name}, you won RPSLS!"
    else
      puts "Sorry, #{computer.name} won RPSLS!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ["y", "n"].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == "n"
    return true if answer.downcase == 'y'
  end

  def display_moves_history
    puts "Your moves: #{human.move_history}"
    puts "#{computer.name}'s moves: #{computer.move_history}"
  end

  def reset_moves
    human.move_history = []
    computer.move_history = []
  end

  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
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