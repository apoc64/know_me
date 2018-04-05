class Node
  attr_reader :character,
              :parent

  attr_accessor :is_end,
                :weight,
                :suggestions,
                :children

  def initialize(character = "", parent = nil, is_end = false)
    @character = character
    @children = []
    @is_end = is_end
    @parent = parent
    @weight = 0

    @suggestions = {}
  end

  def insert(character, is_end = false)
    character = character
    if find_child_node(character).nil?
      node = Node.new(character, self, is_end)
      @children << node
    elsif is_end
      node = change_node_is_end(character)
    else
      node = find_child_node(character)
    end
    node
  end

  def change_node_is_end(character)
    node = find_child_node(character)
    node.is_end = true
    node
  end

  def find_child_node(character)
    @children.each do |child|
      if child.character == character
        return child
      end
    end
    return nil
  end

  def get_end_nodes
    end_nodes = []
    @children.each do |child|
      if child.is_end
        end_nodes << child
      end
      end_nodes += child.get_end_nodes
    end
    end_nodes
  end

  def to_s
    parent.to_s + character
  end

end
