require_relative "../lib/game"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class GameTest < Minitest::Test

  def test_it_exists
    game = Game.new
    assert_instance_of Game, game
  end

  def test_game_has_an_answer
    game = Game.new
    assert_instance_of Integer, game.answer
    assert game.answer > 0
    assert game.answer < 100
  end

  def test_it_can_guess
    game = Game.new
    game.guess(34)
    game.guess(53)
    assert_equal [34,53,47], game.guess(47)
  end

  def test_guess_game_can_evaluate_guesses
    game = Game.new(37)
    game.guess(40)
    assert_equal "You have made 1 guess. Your guess of 40 was too high", game.evaluate_guess
    game.guess(30)
    assert_equal "You have made 2 guesses. Your guess of 30 was too low", game.evaluate_guess
    game.guess(37)
    assert_equal "Your guess of 37 was correct. It took you 3 guesses", game.evaluate_guess
    game = Game.new(75)
    game.guess(70)
    assert_equal "You have made 1 guess. Your guess of 70 was too low", game.evaluate_guess
    game.guess(80)
    assert_equal "You have made 2 guesses. Your guess of 80 was too high", game.evaluate_guess
    game.guess(22)
    game.guess(88)
    game.guess(75)
    assert_equal "Your guess of 75 was correct. It took you 5 guesses", game.evaluate_guess
  end

end
