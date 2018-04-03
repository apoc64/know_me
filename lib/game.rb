class Game
  attr_reader :answer

  def initialize(answer = rand(100))
    @answer = answer
    @guesses = []
  end

  def guess(number)
    @guesses << number.to_i
  end

  def evaluate_guess
    return "You have to guess first" if @guesses.count == 0
    guesses = @guesses.count > 1 ? "#{@guesses.count} guesses" : "1 guess"
    if @guesses[-1] == @answer
      "Your guess of #{@guesses[-1]} was correct. It took you #{guesses}"
    elsif @guesses[-1] > @answer
      "You have made #{guesses}. Your guess of #{@guesses[-1]} was too high"
    else
      "You have made #{guesses}. Your guess of #{@guesses[-1]} was too low"
    end
  end

end
