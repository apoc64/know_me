# require 'simplecov'
# SimpleCov.start
require_relative "../lib/parser"
require_relative "../lib/request"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class ParserTest < Minitest::Test

  def setup
    @p = Parser.new
    @req = Request.new(["GET /hello HTTP/1.1"])
  end

  def test_it_exists
    assert_instance_of Parser, @p
  end

  def test_it_responds
    response = @p.response(@req)
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

  def test_it_can_parse_path
    actual = @p.parse_path(@req)
    assert_equal "<h1>Hello, World! (0)</h1>", actual
    #test other paths
  end

  def test_it_outputs_date_and_time
    date_time = @p.date_time
    assert_equal "<h1>", @p.date_time[0..3]
    assert_equal "</h1>", @p.date_time[-5..-1]
    assert @p.date_time.length > 37
    assert @p.date_time.include?("M on ")
    assert @p.date_time.include?(", 201") #will fail in 2020
  end

  def test_it_can_display_debug_info
    actual = @p.debug(@req)
      #{"Verb" => "GET", "Path" => "/", "Protocol" => "HTTP/1.1", "Host" => "127.0.0.1", "Port" => "9292", "Origin" => "127.0.0.1", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"})
    expected =  "<pre>Verb: GET\nPath: /hello\nProtocol: HTTP/1.1\nHost: N/A\nPort: N/A\nOrigin: N/A\nAccept: N/A</pre>"
    # \nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8</pre>"
    assert_equal expected, actual
  end

  def test_it_can_shutdown
    assert @p.should_continue
    actual = @p.shutdown
    assert_equal "<h1>Total Requests: 0</h1>", actual
    refute @p.should_continue
  end

  def test_it_can_count_total_requests
    @p.response(@req)
    @p.response(@req)
    new_req = Request.new(["GET /shutdown HTTP"])
    output = @p.response(new_req)
    assert output.include?("<h1>Total Requests: 3</h1>")
  end

  def test_it_can_search_words
    # skip
    actual = @p.word_search("pizza")
    assert_equal "<h1>PIZZA is a known word</h1>", actual
    actual = @p.word_search("NIFNBNJ")
    assert_equal "<h1>NIFNBNJ is not a known word</h1>", actual
  end

  def test_it_can_complete_me
    # skip
    cm = @p.complete_me
    assert_instance_of CompleteMe, cm
  end

end
