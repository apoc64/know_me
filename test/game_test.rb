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


end
