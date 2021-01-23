class Move
  attr_reader :value
  VALUES = ["rock", "paper", "scissors", "spock", "lizard"]

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def rock?
    @value == "rock"
  end

  def paper?
    @value == "paper"
  end

  def scissors?
    @value == "scissors"
  end

  def lizard?
    @value == "lizard"
  end

  def spock?
    @value == "spock"
  end
end

class Rock < Move
  def >(other_move)
    (rock? && other_move.scissors?) ||
      (rock? && other_move.lizard?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (rock? && other_move.spock?)
  end
end

class Paper < Move
  def >(other_move)
   (paper? && other_move.rock?) ||
     (paper? && other_move.spock?)
  end

  def <(other_move)
    (paper? && other_move.scissors?) ||
      (paper? && other_move.lizard?)
  end
end

class Scissors < Move
  def >(other_move)
    (scissors? && other_move.paper?) ||
      (scissors? && other_move.lizard?)
  end

  def <(other_move)
    (scissors? && other_move.rock?) ||
      (scissors? && other_move.spock?)
  end
end

class Lizard < Move
  def >(other_move)
    (lizard? && other_move.paper?) ||
      (lizard? && other_move.spock?)
  end

  def <(other_move)
    (lizard? && other_move.rock?) ||
      (lizard? && other_move.scissors?)
  end
end

class Spock < Move
  def >(other_move)
    (spock? && other_move.rock?) ||
      (spock? && other_move.scissors?)
  end

  def <(other_move)
    (spock? && other_move.paper?) ||
      (spock? && other_move.lizard?)
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
      when "rock" then Rock.new(choice)
      when "paper" then Paper.new(choice)
      when "scissors" then Scissors.new(choice)
      when "lizard" then Lizard.new(choice)
      when "spock" then Spock.new(choice)
      end
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
      choice = gets.chomp
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
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
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

  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        display_winner
        display_scores
        break if human.score == WINNING_SCORE || computer.score == WINNING_SCORE
      end
      display_final_winner
      reset_score
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
