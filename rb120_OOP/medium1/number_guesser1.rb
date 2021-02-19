class GuessingGame
  attr_reader :winning_number, :range
  attr_accessor :tries, :guess, :won

  def play
    @winning_number = (1..100).to_a.sample
    @tries = 7
    @won = false
    @guess = 0
    game_loop
    game_result
  end

  def game_loop
    loop do
      puts "You have #{tries} guesses remaining.\n" +
          "Enter a number between 1 and 100: "
      loop do
        self.guess = player_choice
        break if valid_guess(guess)
        puts "Invalid guess. Enter a number between 1 and 100: "
      end
      result(guess)
      break if won || tries == 0
    end
  end

  def player_choice
    self.tries -= 1
    gets.chomp.to_i
  end

  def valid_guess(guess)
    guess > 0 && guess < 101
  end

  def result(guess)
    if guess > winning_number
      puts "Your guess is too high."
    elsif guess < winning_number
      puts "Your guess is too low."
    else
      puts "That's the number!"
      @won = true
    end
    puts "\n"
  end

  def game_result
    if tries == 0
      puts "You have no more guesses. You lost!"
    else
      puts "You won!"
    end
  end
end

game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!