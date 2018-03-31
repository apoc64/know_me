class Parser


  def response(request)
    assemble_response_string
  end

  def assemble_response_string
    output = "<html><head></head><body><h1>Hello World!</h1></body></html>"
    headers = ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    headers + output
  end

  #make hash

  #counter for hellos
  #counter for total requests
  #evaluate path
  #return value for shutdown 

end
