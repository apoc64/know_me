# require 'simplecov'
# SimpleCov.start
require_relative "../lib/parser"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class ParserTest < Minitest::Test

  def setup
    @p = Parser.new
  end

  def test_it_exists
    assert_instance_of Parser, @p
  end

  def test_it_responds
    response = @p.response([""])
    assert_instance_of String, response
    assert_equal "http/1.1 200 ok", response[0..14]
    assert response.length > 175
    assert response.include?("charset=iso-8859-1")
  end

  def test_it_can_assemble_response_string
    response = @p.assemble_response_string
    assert_instance_of String, response
    assert_equal "http/1.1 200 ok", response[0..14]
    assert response.length > 175
    assert response.include?("charset=iso-8859-1")
  end

  def test_it_can_count
    assert_equal "0", @p.response("")[-20]
    @p.hello_counter
    assert_equal "1", @p.response("")[-20]
    @p.hello_counter
    @p.hello_counter
    assert_equal "3", @p.response("")[-20]
  end

end
