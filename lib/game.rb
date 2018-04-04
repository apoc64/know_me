class Game
  attr_reader :answer

  def initialize(answer = rand(100))
    @answer = answer
    @guesses = []
  end

  def guess(number)
    @guesses << number.to_i
  end

  def evaluate_guess(guess = @guesses[-1])
    return "You have to guess first" if @guesses.count == 0
    count = @guesses.count > 1 ? "#{@guesses.count} guesses" : "1 guess"
    if guess == @answer
      "Your guess of #{guess} was correct. It took you #{count}"
    elsif guess > @answer
      "You have made #{count}. Your guess of #{guess} was too high"
    else
      "You have made #{count}. Your guess of #{guess} was too low"
    end
  end

end
