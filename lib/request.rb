class Request
  attr_reader :verb,
  :path,
  :protocol,
  :elements,
  :parameters

  def initialize(request_lines)
    if set_first_line(request_lines[0])
      @elements = make_element_hash(request_lines[1..-1])
    else
      @verb = "N/A"
      @path = "N/A"
      @protocol = "N/A"
    end
  end

  def set_first_line(first_line)
    return nil if first_line.nil?
    lines = first_line.split
    @verb = lines[0]
    if lines[1]
      path_elements = lines[1].split("?")
      @path = path_elements[0]
      @parameters = set_parameters(path_elements[1]) if path_elements[1]
    end
    @protocol = lines[2] if lines[2]
  end

  def set_parameters(path_element)
    all_parameters = path_element.split("&")
    if path_element[1]
      all_parameters.map do |param|
        param.split("=")
      end.to_h
    end
  end

  def make_element_hash(request_lines)
    request_lines.map do |line|
      line.split(": ")
    end.to_h
  end

  def host
    host_elements[0]
  end

  def port
    host_elements[1]
  end

  def host_elements
    if hosts = @elements["Host"]
      hosts.split(":")
    else
      ["N/A", "N/A"]
    end
  end

  def origin
    set_element("Origin")
  end

  def accept
    set_element("Accept")
  end

  def set_element(element)
    if elmt = @elements[element]
      elmt
    else
      "N/A"
    end
  end

  # def value
  #   @params[0][1] if @params[0][1]
  # end

end
