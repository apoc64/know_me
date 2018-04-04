require 'pry'
require_relative 'file_io'
require_relative 'game'

class Router
  attr_reader :should_continue

  def initialize
    @hello_counter = -1
    @total_counter = 0
    @should_continue = true
    @response_code = 200
  end

  def response(request)
    @total_counter += 1
    @req = request
    html_body = parse_path
    assemble_response_string(html_body)
  end

  def parse_path(req = @req)
    case req.path
    when "/" then debug(req)
    when "/hello" then hello_counter
    when "/datetime" then date_time
    when "/shutdown" then shutdown
    when "/word_search" then word_search(req.parameters["word"])
    when "/start_game" then start_game
    when "/game" then game
    when "/force_error" then force_error
    else not_found
    end
  end

  def assemble_response_string(html_body)
    out = output(html_body)
    headers(out.length) + out
  end

  def output(html_body)
    "<html><head></head><body>#{html_body}</body></html>"
  end

  def headers(length, rc = @response_code)
    @response_code = 200
    case rc
    when 200 then normal_header(length)
    when 302 then redirect_header(length)
    when 301 then normal_header(length, "301 Moved Permanently")
    when 401 then normal_header(length, "401 Unauthorized")
    when 403 then normal_header(length, "403 Forbidden")
    when 404 then normal_header(length, "404 Not Found")
    when 500 then normal_header(length, "500 Internal Server Error")
    end
  end

  def normal_header(length, info = "200 ok")
    (["http/1.1 #{info}"] + additional_headers(length)).join("\r\n")
  end

  def redirect_header(length)
    rh = ["http/1.1 302 Found", "Location: http://localhost:9292/game"]
    (rh + additional_headers(length)).join("\r\n")
  end

  # def moved_header(length)
  #   (["http/1.1 301 Moved Permanently"] + additional_headers(length)).join("\r\n")
  # end
  #
  # def unauthorized_header(length)
  #   (["http/1.1 401 Unauthorized"] + additional_headers(length)).join("\r\n")
  # end
  #
  # def forbidden_header(length)
  #   (["http/1.1 403 Forbidden"] + additional_headers(length)).join("\r\n")
  # end
  #
  # def not_found_header(length)
  #   (["http/1.1 404 Not Found"] + additional_headers(length)).join("\r\n")
  # end
  #
  # def error_header(length)
  #   (["http/1.1 500 Internal Server Error"] + additional_headers(length)).join("\r\n")
  # end

  def additional_headers(length)
    ["date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{length}\r\n\r\n"]
  end

  def hello_counter
    @hello_counter += 1
    "<h1>Hello, World! (#{@hello_counter})</h1>"
  end

  def date_time
    "<h1>#{Time.now.strftime('%I:%M%p on %A, %B %d, %Y')}</h1>"
  end

  def debug(req)
    response = "Verb: " + req.verb if req.verb
    response += "\nPath: " + req.path if req.path
    response += "\nProtocol: " + req.protocol if req.protocol
    response += "\nHost: " + req.host
    response += "\nPort: " + req.port
    response += "\nOrigin: " + req.origin
    response += "\nAccept: " + req.accept
    response = "<pre>" + response + "</pre>"
  end

  def shutdown
    @should_continue = false
    "<h1>Total Requests: #{@total_counter}</h1>"
  end

  def word_search(word) #grep?
    return "<h1>Not a valid word</h1>" if word.nil?
    if complete_me.include_word?(word)
      "<h1>#{word.upcase} is a known word</h1>"
    else
      "<h1>#{word.upcase} is not a known word</h1>"
    end
  end

  def complete_me #so it doesn't have to keep reloading
    if @cm.nil? #memoization
      io = FileIO.new
      @cm = io.complete_me
    else
      @cm
    end
  end

  def start_game(req = @req)
    return "<h1>Must POST to start a game</h1>" if req.verb != "POST"
    if @game.nil?
      @game = Game.new
      @response_code = 301
      "<h1>Good luck!</h1>"
    else
      @response_code = 403
      "<h1>Game already running</h1>"
    end
  end

  def game(req = @req)
    return "<h1>You need to start a game first</h1>" if @game.nil?
    if req.verb == "POST"
      guess = req.parameters["guess"]
      @game.guess(guess)
      @response_code = 302
    elsif req.verb == "GET"
      "<h1>" + @game.evaluate_guess + "</h1>"
    end
  end

  def not_found
    @response_code = 404
    "<h1>Not Found 404</h1>"
  end

  def force_error
    @response_code = 500
    call = caller
    "<p>#{call.join}</p>"
  end

end
