require_relative "../lib/game"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class GameTest < Minitest::Test

  def test_it_exists
    game = Game.new
    assert_instance_of Game, game 
  end

end
