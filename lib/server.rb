require 'socket'
require 'pry'
require_relative 'parser'

class Server

def initialize(port)
  @server = TCPServer.new(port)
  @parser = Parser.new
  # @connection?
  connection_loop
end

def connection_loop #runs as long as program is going
  loop do
    puts "Ready For request" # can delete
    connection = @server.accept
    request = get_request(connection)
    puts "Got the request: " + request.inspect
    response = @parser.response(request)
    connection.puts response
    #shutdown receiver?
  end
end

def get_request(connection)
  request_lines = []
  while (line = connection.gets) && (!line.chomp.empty?)
    request_lines << line.chomp
  end
  request_lines
  #make it a hash?
end

end

s = Server.new(9292)
