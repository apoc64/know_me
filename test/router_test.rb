require_relative "../lib/router"
require_relative "../lib/request"
require 'pry'
require "Minitest/autorun"
require "Minitest/pride"

class RouterTest < Minitest::Test

  def setup
    @p = Router.new
    @req = Request.new(["GET /hello HTTP/1.1"])
  end

  def test_it_exists
    assert_instance_of Router, @p
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
    assert_equal "<h1>Hello, World! (0)</h1>", @p.hello_counter
    assert_equal "<h1>Hello, World! (1)</h1>", @p.hello_counter
    assert_equal "<h1>Hello, World! (2)</h1>", @p.hello_counter
  end

  def test_it_can_parse_path
    actual = @p.parse_path(@req)
    assert_equal "<h1>Hello, World! (0)</h1>", actual
    req = Request.new(["GET /start_game HTTP/1.1"])
    actual = @p.parse_path(req)
    assert_equal "<h1>Must POST to start a game</h1>", actual
    req = Request.new(["GET / HTTP/1.1"])
    actual = @p.parse_path(req)
    assert actual.include?("<pre>Verb: GET\nPath: /")
    #time to load complete me:
    req = Request.new(["GET /word_search?word=pizza HTTP/1.1"])
    @p.response(req)
    actual = @p.parse_path(req)
    assert actual.include?("<h1>PIZZA is a known word</h1>")
    #test other paths
  end

  def test_it_outputs_date_and_time
    assert_equal "<h1>", @p.date_time[0..3]
    assert_equal "</h1>", @p.date_time[-5..-1]
    assert @p.date_time.length > 37
    assert @p.date_time.include?("M on ")
    assert @p.date_time.include?(", 201") #will fail in 2020
  end

  def test_it_can_display_debug_info
    actual = @p.debug(@req)
    expected =  "<pre>Verb: GET\nPath: /hello\nProtocol: HTTP/1.1\nHost: N/A\nPort: N/A\nOrigin: N/A\nAccept: N/A</pre>"
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
    # skip #time to load complete me
    @p.response(@req)
    actual = @p.word_search("pizza")
    assert_equal "<h1>PIZZA is a known word</h1>", actual
    actual = @p.word_search("NIFNBNJ")
    assert_equal "<h1>NIFNBNJ is not a known word</h1>", actual
  end

  def test_it_can_complete_me
    # skip # time to load complete me
    cm = @p.complete_me
    assert_instance_of CompleteMe, cm
  end

  def test_it_can_start_game
    new_req = Request.new(["POST / HTTP"])
    assert_equal "<h1>Good luck!</h1>", @p.start_game(new_req)
  end

  def test_it_has_game
    assert_equal "<h1>You need to start a game first</h1>", @p.game
    req = Request.new(["POST /game HTTP/1.1", "host: frre"])
    req.set_request_body("guess=55")
    @p.start_game(req)
    assert_equal 302, @p.game(req)
    req = Request.new(["GET /game?guess=55 HTTP/1.1", "host: frre"])
    result = @p.game(req)
    assert_equal "<h1>You", result[0..6]
    assert result.include?("Your guess of 55")
  end

  def test_header
    h = @p.headers(5)
    assert_instance_of String, h
    assert h.include?("content-length: 5\r\n\r\n")
    assert h.include?("http/1.1 200 ok")

    h = @p.headers(7, 302)
    assert_instance_of String, h
    assert h.include?("content-length: 7\r\n\r\n")
    assert h.include?("http/1.1 302 Found")
  end

  def test_output
    actual = @p.output("Hello")
    expected = "<html><head></head><body>Hello</body></html>"
    assert_equal expected, actual
  end

  def test_normal_header
    nh = @p.normal_header(9)
    assert nh.include?("http/1.1 200 ok\r\ndate: ")
    assert nh.include?("content-length: 9\r\n\r\n")
  end

  def test_redirect_header
    rh = @p.redirect_header(11)
    assert rh.include?("http/1.1 302 Found\r\nLocation: http://localhost:9292/game\r\ndate: ")
    assert rh.include?("content-length: 11\r\n\r\n")
  end

  def test_additional_headers
    actual = @p.additional_headers(15)
    expected = ["date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: 15\r\n\r\n"]
    assert_equal expected, actual
  end

  def test_it_can_not_found
    assert_equal "<h1>Not Found 404</h1>", @p.not_found
  end

  def test_it_can_force_error
    assert_instance_of String, @p.force_error
    assert @p.force_error.length > 100
    assert_equal "<p>", @p.force_error[0..2]
  end

end
