require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'
require 'pry'
class ServerTest < Minitest::Test
#
#   # def test_it_exists
#   # assert_instance_of Server,
#   # end
#
  def test_it_responds_to_request
    # skip
    response = Faraday.get 'http://localhost:9292'
    assert_equal response.status, 200
  end
#
end
