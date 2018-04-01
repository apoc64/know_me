require 'pry'

class Parser

  def initialize
    @hello_counter = -1
  end

  def response(request_lines)
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
  def make_request_hash(request_lines)
    # binding.pry #must handle bad formatting
    request = {}
    first_line = request_lines[0].split
    request["Verb"] = first_line[0]
    request["Path"] = first_line[1]
    request["Protocol"] = first_line[2]
    request_lines.each do |line|
      # binding,pry
      split = line.split(": ")
      request[split[0]] = split[1]
    end
    host = request["Host"].split(":")
    request["Host"] = host[0] #split host/port
    request["Port"] = host[1]
    # binding.pry
    request
  end

  #counter for hellos
  def hello_counter
    @hello_counter += 1
    "<h1>Hello, World! (#{@hello_counter})</h1>"
  end

  def date_time
    "<h1>#{Time.now.strftime('%I:%M%p on %A, %B %d, %Y')}</h1>"
  end

  def debug(request)
    response = "<pre>\n"
    response += "Verb: " + request["Verb"] + "\n"
    response += "Path: " + request["Path"] + "\n"
    response += "Protocol: " + request["Protocol"] + "\n"
    response += "Host: " + request["Host"] + "\n"
    response += "Port: " + request["Port"] + "\n"
    response += "Origin: " + request["Origin"] + "\n" if request["Origin"] #doesn't happen on Chrome
    response += "Accept: " + request["Accept"] + "\n"
    response += "</pre>"
  end

  #counter for total requests
  #evaluate path
  #return value for shutdown

end
