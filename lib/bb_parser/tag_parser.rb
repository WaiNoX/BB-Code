require 'bb_parser/tag_types.rb'

class TagParser
  
  # 0: Alles
  # 1: ""->öfnend, "/"->schließend
  # 2: tag name
  # 3: 'parameter'
  # 4: "parameter"
  # 5: parameter
  
  @@matcher = /\A\[(\/?)([a-z*]+)(?:=(?:(?:'([^"'\[]+)')|(?:"([^"'\[]+)")|(?:([^"'\[]+))))?\]\z/ix
    
  def self.is_valid_name(tag_name)
    tag_symbol = tag_name.to_sym
    return !(TagTypes.get_info(tag_symbol).nil?)
  end
  
  def self.is_tag(tag)
    return !tag.match(@@matcher).nil?
  end
  
  def initialize(tag)
    data = tag.match(@@matcher)
    @original = tag
    @closing = data[1] == '/'
    @tag_name = data[2]
    @tag_data = data[5] || data[4] || data[3]
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
    this_info = TagTypes.get_info(@tag_name)
    that_info = TagTypes.get_info(tag_name)
    if(this_info.nil? || that_info.nil?) #keine handler da
      return false
    elsif(this_info[:allows_all_tags] && that_info[:allowed_in_all])# ich erlaube alles und es erlaubt auch alles
      return true
    elsif(this_info[:allows_all_tags] && that_info[:allowed_in].include?(@tag_name)) #ich erlaube alles und es will zu mir
      return true
    elsif(that_info[:allowed_in_all] && this_info[:allowed_tags].include?(tag_name)) # es darf überall hin und ich erlaube es
      return true
    elsif(that_info[:allowed_in].include?(@tag_name) && this_info[:allowed_tags].include?(tag_name)) #ich erlaube es und es will zu mir
      return true
    else # ich erlaube den tag nicht
      return false
    end
  end
end
