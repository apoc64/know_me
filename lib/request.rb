class Request

  def initialize(request_lines)
    if set_first_line(request_lines[0])
      set_remaining_values(request_lines[1..-1])
    end
  end

  def set_first_line(first_line)
    return nil if first_line.nil?
    elements = first_line.split
    @verb = elements[0]
    if elements[1]
      path_elements = elements[1].split("=")
      @path = path_elements[0]
      @value = path_elements[1]
    end
    @protocol = elements[2] if elements[2]
  end 

end
