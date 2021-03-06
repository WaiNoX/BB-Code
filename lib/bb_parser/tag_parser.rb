require 'bb_parser/tag_types.rb'

class TagParser
  
  # 0: Alles
  # 1: ""->öfnend, "/"->schließend
  # 2: tag name
  # 3: 'parameter'
  # 4: "parameter"
  # 5: parameter
  
  @@tag_matcher = /\A\[(\/?)([a-z*]+)(?:=(?:(?:'([^"'\[<]+)')|(?:"([^"'\[<]+)")|(?:([^"'\[<]+))))?\]\z/ix
  @@url_matcher = /\A((?:[a-z]+:\/\/|www.)[^<\s]+\.[^<\s]+)\z/ix
    
  def self.is_valid_name(tag_name)
    tag_symbol = tag_name.to_sym
    return !(TagTypes.get_info(tag_symbol).nil?)
  end
  
  def self.is_allowed_master(tag_name)
    tag_symbol = tag_name.to_sym
    return is_valid_name(tag_name) && TagTypes.get_info(tag_symbol)[:allowed_in_all]
  end
  
  def self.is_tag(tag)
    return !tag.match(@@tag_matcher).nil?
  end
  
  def self.is_url(url)
    return !url.match(@@url_matcher).nil?
  end
  
  def initialize(tag)
    data = tag.match(@@tag_matcher)
    if(data.nil?)
      return
    end
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
    if(closing?) # wenn tag schließt auch keine unterknoten erlauben
      return false
    end
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
