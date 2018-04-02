class Request
  attr_reader :verb,
              :path,
              :protocol,
              :value,
              :elements

  def initialize(request_lines)
    if set_first_line(request_lines[0])
      @elements = make_element_hash(request_lines[1..-1])
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

  def make_element_hash(request_lines)
    request_lines.map do |line|
      line.split(": ")
    end.to_h
  end

end
