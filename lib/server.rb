require 'socket'
require 'pry'
require_relative 'parser'

class Server

  def initialize(port)
    server = TCPServer.new(port)
    parser = Parser.new
    connection_loop(server, parser)
  end

  def connection_loop(server, parser)
    while parser.should_continue
      puts "Ready For request"
      client = server.accept
      # request = get_request(connection)
      req = Request.new(get_request(client))
      puts "Got the request: " + req.inspect
      response = parser.response(req)
      connection.puts response
    end
  end

  def get_request(client)
    request_lines = []
    while (line = connection.gets) && (!line.chomp.empty?)
      request_lines << line.chomp
    end
    request_lines
  end

end

s = Server.new(9292)
