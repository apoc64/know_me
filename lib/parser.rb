require 'pry'
#require 'complete_me'?

class Parser
  attr_reader :should_continue

  def initialize
    @hello_counter = -1
    @total_counter = 0
    @should_continue = true
  end

  def response(request_lines)
    @total_counter += 1
    request = make_request_hash(request_lines)
    puts request
    html_body = parse_path(request)
    assemble_response_string(html_body)
  end

  def parse_path(request)
    case request["Path"]
    when "/" then debug(request)
    when "/hello" then hello_counter
    when "/datetime" then date_time
    when "/shutdown" then shutdown
    when "/word_search?word" then word_search(request["Value"])
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

  #make hash
  def make_request_hash(request_lines) #extract methods?
    # binding.pry #must handle bad formatting
    request = {}
    first_line = request_lines[0].split
    request["Verb"] = first_line[0]

    if first_line[1]
      path_elements = first_line[1].split("=")
      request["Path"] = path_elements[0] #split values?
      request["Value"] = path_elements[1]
    end

    request["Protocol"] = first_line[2]
    request_lines.each do |line|
      # binding.pry
      split = line.split(": ")
      request[split[0]] = split[1]
    end
    if request["Host"]
      host = request["Host"].split(":")
      request["Host"] = host[0] #split host/port
      request["Port"] = host[1]
    end
    # binding.pry
    request
  end

  def hello_counter
    @hello_counter += 1
    "<h1>Hello, World! (#{@hello_counter})</h1>"
  end

  def date_time
    "<h1>#{Time.now.strftime('%I:%M%p on %A, %B %d, %Y')}</h1>"
  end

  def debug(req) #Chrome doesn't have 'Origin'... more guards?
    response = "Verb: " + req["Verb"]
    response += "\nPath: " + req["Path"]
    response += "\nProtocol: " + req["Protocol"]
    response += "\nHost: " + req["Host"]
    response += "\nPort: " + req["Port"]
    response += "\nOrigin: " + req["Origin"] if req["Origin"]
    response += "\nAccept: " + req["Accept"]
    response = "<pre>" + response + "</pre>"
  end

  def shutdown
    @should_continue = false
    "<h1>Total Requests: #{@total_counter}</h1>"
  end

  def word_search(word)

  end 

end
