require 'pry'
require_relative 'file_io'

class Router
  attr_reader :should_continue

  def initialize
    @hello_counter = -1
    @total_counter = 0
    @should_continue = true
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
    end
  end

  def assemble_response_string(html_body)
    output = "<html><head></head><body>#{html_body}</body></html>"
    headers = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    headers + output
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

  def word_search(word)
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
    if req.verb == "POST"
      #start a game
      "Good luck!"
    else
      "Must post to start a game"
    end
  end

  def game(req = @req)
    if req.verb == "POST"
      #make a guess
      #redirect to get
    elsif req.verb == "GET"
      #display game info
    end
  end

end
