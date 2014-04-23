class BBCodeParser
  #list of bbcodes
  @bbcodes = Hash.new
  
  #outout type
  @output_type = 'text/html'
  
  #source text
  @text = ''
  
  #parsed text
  @parsed_text = ''
  
  #tag array
  @tag_array = Hash.new
  
  #text array
  @text_array = Hash.new
  
  def initialize
    @bbcodes = BBCodeCache.new.getBBCodes
  end
  
  def set_output_type(output_type)
    @output_type = output_type
  end
  
  def get_output_type
    return @output_type
  end
  
  def set_text(text)
    @text = text
  end
  
  def parse(text)
    set_text(text)
    build_tag_array
    build_xml_structure
    build_parsed_string
    return @parsed_text
  end
  
  def build_xml_structure
    open_tag_stack = open_tag_data_stack = Array.new
    new_tag_array = Array.new
    new_text_array = Array.new
    
    i = -1
    @tag_array.each { |i, tag| 
      if(tag['closing']) #closing tag
        if(open_tag_stack.include?(tag['name']) && is_allowed(open_tag_stack, tag['name'], true))
          tmp_open_tags = Array.new
          while ((previous_tag = open_tag_stack.last) != tag['name'])
            next_index = new_tag_array.count
            new_tag_array[next_index] = build_tag('[/'+previous_tag+']')
            if( not new_text_array[next_index].exists?) 
              new_text_array[next_index] = ''
            end
            new_text_array[next_index] += @text_array[i]
            @text_array[i] = ''
            tmp_open_tags.push(open_tag_data_stack.last)
            open_tag_stack.pop
            open_tag_data_stack.pop
          end
          next_index = new_tag_array.count
          new_tag_array[next_index] = tag
          
        end
      end
    }
  end
  
  def is_valid_tag(tag)
    if(tag['attributes'].exists? && tag['attributes'].count > @bbcodes[tag['name']].get_attributes.count)
      return false
    end
    @bbcodes[tag['name']].get_attributes.each { |attribute| 
      if(not is_valid_tag_attribute(tag['attributes'].exists?)?tag['attributes']:Array.new)
        return false
      end
    }
    return true
  end

  def is_allowed(open_tags, tag, closing = false)
    open_tags.each { |open_tag|
      if (closing && open_tag == tag)
        next
      end
      if (@bbcodes[open_tag].allowed_children == all)
        next
      end
      if  (@bbcodes[open_tag].allowed_children == none)
        return false
      end
      
      arguments = @bbcodes[open_tag].allowed_children.split('^')
      if arguments[1].exists?
        tags = arguments[1].split(',')
      else
        tags = Array.new
      end
      
      if(arguments[0] == 'none' && ! tags.include?(tag))
        return false
      end
      if(arguments[0] == 'all' && tags.include?(tag))
        return false
      end
    }
    return true
  end
end
