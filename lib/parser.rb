require 'pry'
require_relative 'file_io'
# require_relative '../../complete_me_project/Complete_Me/lib/complete_me'

class Parser
  attr_reader :should_continue

  def initialize
    @hello_counter = -1
    @total_counter = 0
    @should_continue = true
  end

  def response(request)
    @total_counter += 1
    @req = request
    # request = make_request_hash(request_lines)
    # puts request
    html_body = parse_path
    assemble_response_string(html_body)
  end

  def parse_path(req = @req)
    case req.path
    when "/" then debug(req)
    when "/hello" then hello_counter
    when "/datetime" then date_time
    when "/shutdown" then shutdown
    when "/word_search?word" then word_search(req.value)
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

  #make hash - REFACTOR!!!
  # def make_request_hash(request_lines) #extract methods?
  #   # binding.pry #must handle bad formatting
  #   request = {}
  #   first_line = request_lines[0].split
  #   request["Verb"] = first_line[0]
  #
  #   if first_line[1]
  #     path_elements = first_line[1].split("=")
  #     request["Path"] = path_elements[0] #split values?
  #     request["Value"] = path_elements[1]
  #   end
  #
  #   request["Protocol"] = first_line[2]
  #   request_lines.each do |line|
  #     # binding.pry
  #     split = line.split(": ")
  #     request[split[0]] = split[1]
  # #   end
  #   if request["Host"]
  #     host = request["Host"].split(":")
  #     request["Host"] = host[0] #split host/port
  #     request["Port"] = host[1]
  #   end
  #   # binding.pry
  #   request
  # end

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
    if complete_me.include_word?(word)
      "<h1>#{word.upcase} is a known word</h1>"
    else
      "<h1>#{word.upcase} is not a known word</h1>"
    end
  end

  def complete_me #so it doesn't have to keep reloading
    if @cm.nil?
      io = FileIO.new
      @cm = io.complete_me
    else
      @cm
    end
  end

end
