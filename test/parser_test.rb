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
    response = @p.assemble_response_string("<h1>Hello World!</h1>")
    assert_instance_of String, response
    assert_equal "http/1.1 200 ok", response[0..14]
    assert_equal response.length, 197
    assert response.include?("charset=iso-8859-1")
  end

  def test_it_can_count
    # skip
    assert_equal "<h1>Hello, World! (0)</h1>", @p.hello_counter
    assert_equal "<h1>Hello, World! (1)</h1>", @p.hello_counter
    assert_equal "<h1>Hello, World! (2)</h1>", @p.hello_counter
  end

  def test_it_makes_a_hash
    request_lines = ["l: x", "z: r"]
    request = @p.make_request_hash(request_lines)
    assert_instance_of Hash, request
  end

  def test_it_can_parse_path
    actual = @p.parse_path("/hello")
    assert_equal "<h1>Hello, World! (0)</h1>", actual
  end

  def test_it_outputs_date_and_time
    date_time = @p.date_time
    assert_equal "<h1>", @p.date_time[0..3]
    assert_equal "</h1>", @p.date_time[-1..-5]
    assert @p.date_time.length > 37
    assert @p.date_time.include?("M on ")
    assert @p.date_time.include?(", 201") #will fail in 2020
  end

end
