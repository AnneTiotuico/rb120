class GuessingGame
  def initialize(low, high)
    self.low = low
    self.high = high
    self.range = (low..high).to_a
    self.player = Player.new
    @secret_num
    @number_of_guesses
  end

  def play
    reset_game_state
    loop do
      display_remaining_guesses
      subtract_guess_count
      ask_for_guess
      compare_guess
      break if guesses_are_zero? || won?
    end
  end

  private
  attr_accessor :range, :low, :high, :number_of_guesses, :player, :secret_num

  def reset_game_state
    self.secret_num = range.sample
    self.number_of_guesses = Math.log2(range.length).to_i + 1
  end

  def display_remaining_guesses
    puts "You have #{number_of_guesses} guesses remaining."
  end

  def subtract_guess_count
    self.number_of_guesses -= 1
  end

  def ask_for_guess
    loop do
      print "Enter a number between #{low} and #{high}:"
      input = player.make_guess
      break if input.between?(low, high)
      print "Invalid guess. "
    end
  end

  def compare_guess
    if player.guess == secret_num
      puts "That's the number!"
    elsif player.guess < secret_num
      puts "Your guess is too low."
    else
      puts "Your guess is too high."
    end
  end

  def guesses_are_zero?
    number_of_guesses == 0
  end

  def won?
    player.guess == secret_num
  end

end

class Player
  attr_reader :guess

   def initialize
      @guess
   end
   def make_guess
     self.guess = gets.chomp.to_i
   end

  private
  attr_writer :guess

end


game = GuessingGame.new(501, 1500)
game.play