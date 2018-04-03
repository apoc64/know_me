class Game
  attr_reader :answer

  def initialize(answer = rand(100))
    @answer = answer
  end

end
