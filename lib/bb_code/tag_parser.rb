require 'bb_code/tag_types.rb'

class TagParser
  
  def self.is_valid_name(tag_name)
    tag_symbol = tag_name.to_sym
    return !(TagTypes.get_info(tag_symbol).nil?)
  end
  
  def initialize(tag)
    @original = tag
    @closing = tag[1] == "/"
    index = tag.index("=")
    if index.nil?
      index = tag.index(']')
    end
    @tag_name = tag[(@closing?2:1)..(index-1)]
    if(not tag.index("=").nil?)
      @tag_data = tag[(tag.index("=")+1)..(tag.index("]")-1)].gsub(/['"']/, "").split(",")
    else
      @tag_data = []
    end
  end
  
  def closing?
    return @closing
  end
  
  def tag_name
    return @tag_name
  end
  
  def get_data
    return @tag_data
  end
  
  def name
    return @tag_name
  end
  
  def original
    return @original
  end
  
  def allows?(tag_name)
    tag_info = TagTypes.get_info(@tag_name)
    if(tag_info.nil?) #kein handler da
      return false
    elsif(tag_info[:allows_all_tags])# ich erlaube alles
      return true
    elsif(tag_info[:allowed_tags].include?(tag_name.downcase)) #ich erlaube den tag
      return true
    else # ich erlaube den tag nicht
      return false
    end
  end
end
