require 'pry'

class Parser

  def initialize
    @hello_counter = -1
  end

  def response(request_lines)
    request = make_request_hash(request_lines)
    puts request


    html_body = parse_path(request["Path"])
    assemble_response_string(html_body)
  end

  def parse_path(path)
    body = ""
    case path
    when "/hello" then body = hello_counter
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
    # binding.pry
    request
  end

  #counter for hellos
  def hello_counter
    @hello_counter += 1
    "<h1>Hello, World! (#{@hello_counter})</h1>"
  end

  #counter for total requests
  #evaluate path
  #return value for shutdown

end
