require 'socket'
require 'pry'
require_relative 'router'
require_relative 'request'

class Server

  def initialize(port)
    server = TCPServer.new(port)
    router = Router.new
    connection_loop(server, router)
  end

  def connection_loop(server, router)
    while router.should_continue
      puts "Ready For request"
      client = server.accept
      req = Request.new(get_request(client))
      puts "Got the request: " + req.inspect
      get_body_request(req, client)
      response = router.response(req)
      client.puts response
      puts "Sent the response: " + response
    end
  end

  def get_request(client)
    request_lines = []
    while (line = client.gets) && (!line.chomp.empty?)
      request_lines << line.chomp
    end
    request_lines
  end

  def get_body_request(req, client)
    if req.elements["Content-Length"]
      length = req.elements["Content-Length"].to_i
      puts "Content-Length: " + length.to_s
      content = client.read(length)
      puts content
    end

  end

end

s = Server.new(9292) #move before testing
