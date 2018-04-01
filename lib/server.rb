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
      connection = server.accept
      request = get_request(connection)
      puts "Got the request: " + request.inspect
      response = parser.response(request)
      connection.puts response
    end
  end

  def get_request(connection)
    request_lines = []
    while (line = connection.gets) && (!line.chomp.empty?)
      request_lines << line.chomp
    end
    request_lines
  end

end

s = Server.new(9292)
