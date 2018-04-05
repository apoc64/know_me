require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/server'
require 'pry'
class ServerTest < Minitest::Test

  def test_it_responds_to_request
    response = Faraday.get 'http://localhost:9292'
    assert_equal response.status, 200
    assert_equal response.body, "<html><head></head><body><pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: localhost\nPort: 9292\nOrigin: N/A\nAccept: */*</pre></body></html>"
    assert_equal response.headers["server"], "ruby"
  end

  def test_it_can_search_words
    # skip # Time to load complete me
    response = Faraday.get 'http://localhost:9292/word_search?word=monkey'
    assert_equal response.status, 200
    assert_equal response.body, "<html><head></head><body><h1>MONKEY is a known word</h1></body></html>"

    response = Faraday.get 'http://localhost:9292/word_search?word=xqzyk'
    assert_equal response.status, 200
    assert_equal response.body, "<html><head></head><body><h1>XQZYK is not a known word</h1></body></html>"
  end

  def test_it_can_not_found
    response = Faraday.get 'http://localhost:9292/cfrvdvevre'
    assert_equal response.status, 404
    assert_equal response.body, "<html><head></head><body><h1>Not Found 404</h1></body></html>"
  end

  def test_it_can_count_hellos #must reset server prior to running
    # skip
    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal response.status, 200
    assert_equal response.body, "<html><head></head><body><h1>Hello, World! (0)</h1></body></html>"

    response = Faraday.get 'http://localhost:9292/hello'
    assert_equal response.status, 200
    assert_equal response.body, "<html><head></head><body><h1>Hello, World! (1)</h1></body></html>"
  end

end
