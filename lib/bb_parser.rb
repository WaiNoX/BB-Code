require 'bb_code/tag_types.rb'  #tagdefinitionen
require 'bb_code/tag_parser.rb' #tagparser
require 'bb_code/node.rb'       #tree
require 'bb_code/tag_handler.rb'#handler
require 'cgi'                   #escapen
require 'pry'                   #debug


module BbParser
  
  #@@regex_woltlab = /\[(?:\/(?:[a-z]+)|(?:[a-z]+)(?:=(?:\'[^\'\\]*(?:\\.[^\'\\]*)*\'|[^,\]]*)(?:,(?:\'[^\'\\]*(?:\\.[^\'\\]*)*\'|[^,\]]*))*)?)\]/ix
  @@regex = /(\[\/?[a-z*]+(?:=(?:(?:'[^"'\[]+')|(?:"[^"'\[]+")|(?:[^"'\[]+)))?\])/ix

  def self.bb_to_html(text)
    text_array = parse_tokens(text)
    tree = build_tree text_array
    return tree_to_html(tree)
  end
  
  private
  
  def self.parse_tokens(text)
    text.split(@@regex)
  end
  
  #Baut aus dem TokenArray einen Baum auf, der die regeln aus TagTypes befolgt
  def self.build_tree(text_array)
    tree = Node.new('', :master, nil)
    parent_node = tree
    
    text_array.each { |item| 
      if(item.index(@@regex) == 0) #ist ein Tag
#        binding.pry
        tag = TagParser.new item
        if(tag.closing? && parent_node.get_type == :master) #wenn kein offener tag mehr da -> text
          node = Node.new(item, :text, parent_node)
          parent_node.add_child(node)
        elsif(tag.closing? && parent_node.get_tag.name == tag.name) #wenn der schließende tag passt eine ebene nach oben
          parent_node = parent_node.get_parent
        elsif((not tag.closing?)) #wenn sich ein neuer gültiger tag öffnet hinzufügen und runter
          if (parent_node.get_type == :master && TagParser.is_valid_name(tag.tag_name)) #ein tag ist gültig wenn er in @@tags steht und in :master eingehängt werden soll
            node = Node.new(item, :tag, parent_node)
            parent_node.add_child(node)
            parent_node = node
          elsif((!parent_node.get_tag.nil?) && parent_node.get_tag.allows?(tag.tag_name)) # oder wenn der elternknoten ihn erlaubt
            node = Node.new(item, :tag, parent_node)
            parent_node.add_child(node)
            parent_node = node
          else #falsch schließende tags oder unbekannte tags werden als text behandelt
            node = Node.new(item, :text, parent_node)
            parent_node.add_child(node)
          end
        else #fehler!! was immer es ist wird als text behandelt, damit der anwender es sehen kann
          node = Node.new(item, :text, parent_node)
          parent_node.add_child(node)
        end
      else #text
        node = Node.new(item, :text, parent_node)
        parent_node.add_child(node)
      end
    }
    return tree
  end
  
  def self.tree_to_html(node)
    if(node.get_type == :text) #returne den für html escapten string, texte haben keine unterknoten
      return CGI.escapeHTML(node.get_text)
    elsif (node.get_type == :master) #returne die erstellten texte aller unterknoten
      childtext = ''
      node.get_childs.each{|childnode|
        childtext= childtext + tree_to_html(childnode)
      }
      return childtext
    elsif (node.get_type == :tag) #returne das ergebniss der Tag-Klasse angewendet auf dne starttag und die texte der unterknoten
      childtext = ''
      node.get_childs.each{|childnode|
        childtext= childtext + tree_to_html(childnode)
      }
      tag = node.get_tag
      begin
        clazz = Object.const_get((TagTypes.get_info(tag.name)[:handler]))
        return clazz.parse_to_html(tag, childtext)
      rescue NameError #klasse nicht vorhanden, also auch kein gültiger tag, returne den escapten tag-text gefolgt vom text der unterknoten
        return FailTag.parse_to_html(tag, childtext)
      end
    end
  end
end

String.class_eval do
  # Convert a string with BBCode markup into its corresponding HTML markup
  def bbcode_to_html(text)
    return BbParser.bb_to_html(text)
  end
end
