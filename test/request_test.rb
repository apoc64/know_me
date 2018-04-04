require_relative "../lib/request"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class RequestTest < Minitest::Test

  def setup
    @req = Request.new(["GET /hello HTTP/1.1", "Host: localhost:9292", "Accept: */*", "Origin: Yo!", "Godzilla: Monster"])
  end

  def test_it_exists
    assert_instance_of Request, @req
  end

  def test_it_can_set_first_line
    @req.set_first_line("POST /word_search?word=pizza HTTP/1.2")
    assert_equal "POST", @req.verb
    assert_equal "/word_search", @req.path
    assert_equal "pizza", @req.parameters["word"]
    assert_equal "HTTP/1.2", @req.protocol
  end

  def test_it_can_set_parameters
    actual = @req.set_parameters("word=pizza&guess=87")
    expected = {"word" => "pizza", "guess" => "87"}
    assert_equal expected, actual
  end

  def test_it_can_make_element_hash
    actual = @req.make_element_hash(["Host: 127.0.0.1:8787", "Accept: */lots*", "Origin: YoYoYo!"])
    expected = {"Host" => "127.0.0.1:8787", "Accept" => "*/lots*", "Origin" => "YoYoYo!"}
    assert_equal expected, actual
  end

  def test_it_returns_a_host
    assert_equal "localhost", @req.host
  end

  def test_it_returs_a_port
    assert_equal "9292", @req.port
  end

  def test_it_returns_host_elements
    assert_equal ["localhost", "9292"], @req.host_elements
  end

  def test_it_returns_origin
    assert_equal "Yo!", @req.origin
  end

  def test_it_returns_accept
    assert_equal "*/*", @req.accept
  end

  def test_it_can_set_elements
    assert_equal "Monster", @req.set_element("Godzilla")
  end

  def test_it_sets_body_content
    @req.set_request_body("guess=55&monster=godzilla")
    assert_equal "55", @req.body_params["guess"]
  end


end
