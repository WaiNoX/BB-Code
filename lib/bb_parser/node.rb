require 'bb_parser/tag_parser.rb'

class Node
  def initialize (text, type, parent)
    #puts text
    @text = text
    @type = type
    @parent = parent
    @childs = []
    if(@type == :tag)
      @tag = TagParser.new @text
    end
  end
  
  def add_child(node)
    @childs.push(node)
  end
  
  def get_childs
    return @childs
  end
  
  def get_type
    return @type
  end
  
  def get_parent
    return @parent
  end
  
  def get_text
    return @text
  end
  
  def get_tag
    if @type == :tag
      return @tag
    else
      return nil
    end
  end
end