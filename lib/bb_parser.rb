require 'bb_parser/tag_types.rb'  #tagdefinitionen
require 'bb_parser/tag_parser.rb' #tagparser
require 'bb_parser/node.rb'       #tree
require 'bb_parser/tag_handler.rb'#handler
require 'cgi'                     #escapen
require 'pry'                     #debug


class BbParser
  
  @@tokenizer = /(?:(\[\/?[a-z*]+(?:=(?:(?:'[^"'\[]+')|(?:"[^"'\[]+")|(?:[^"'\[]+)))?\])|(\A|\s)((?:[a-z]+:\/\/|www.)[^<\s]+\.[^<\s]+))/ix #mit autolink
  
  def self.bb_to_html(text)
    text_array = parse_tokens(text)
    tree = build_tree text_array
    return tree_to_html(tree)
  end
  
  private
  
  def self.parse_tokens(text)
    text.split(@@tokenizer)
  end
  
  #Baut aus dem TokenArray einen Baum auf, der die regeln aus TagTypes befolgt
  def self.build_tree(text_array)
    tree = Node.new('', :master, nil)
    parent_node = tree
    
    text_array.each { |item| 
      if(TagParser.is_tag(item))
#        binding.pry # debug
        tag = TagParser.new item
        if(tag.closing? && parent_node.get_type == :master) #wenn kein offener tag mehr da -> text
          node = Node.new(item, :text, parent_node)
          parent_node.add_child(node)
        elsif(tag.closing? && parent_node.get_tag.name.downcase == tag.name.downcase) #wenn der schließende tag passt eine ebene nach oben
          parent_node = parent_node.get_parent
        elsif((not tag.closing?)) #wenn sich ein neuer gültiger tag öffnet hinzufügen und runter
          if (parent_node.get_type == :master && TagParser.is_allowed_master(tag.tag_name)) #ein tag ist gültig wenn er in @@tags steht und in :master eingehängt werden soll
            node = Node.new(item, :tag, parent_node)
            parent_node.add_child(node)
            parent_node = node
          elsif((!parent_node.get_tag.nil?) && parent_node.get_tag.allows?(tag.tag_name)) # oder wenn sie sich gegenseitig tollerieren
            node = Node.new(item, :tag, parent_node)
            parent_node.add_child(node)
            parent_node = node
          else #ubekannte tags werden als text behandelt
            node = Node.new(item, :text, parent_node)
            parent_node.add_child(node)
          end
        else #eingabefehler, schließender tag passt nicht usw
          node = Node.new(item, :text, parent_node)
          parent_node.add_child(node)
        end
      elsif(TagParser.is_url(item)) #autourl darf nicht einfach nen url tag ausspucken, da es eventuell in einem img/url tag benutzt wird
        if( parent_node.get_type == :master  || (!parent_node.get_tag.nil? && parent_node.get_tag.allows?('url'))) # wenn parent_tag erlaubt baue einen url tag zum anhängen
          url_tag = Node.new('[url]', :tag, parent_node) #node für den url_tag erstellen
          url = Node.new(item, :text, url_tag) #node für den text erstellen
          url_tag.add_child(url) #text in tag einhängen
          parent_node.add_child(url_tag) #das ganze an den paren hängen
#          url = '<a href="' + item + '">' + item + '</a>' # das darf leider kein richtiger tag sein, da sonnst der schließende fehlen würde, wobei sich das auc machen ließe
#          node = Node.new(url, :url, parent_node)
#          parent_node.add_child(node)
        else #anernfalls ist es nur text
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
      return  CGI.escapeHTML(node.get_text)
#    elsif(node.get_type == :url) #returne den unescapten string, url haben keine unterknoten
#      return node.get_text
    elsif (node.get_type == :master) #returne die erstellten texte aller unterknoten
      childtext = ''
      node.get_childs.each{|childnode|
        childtext = childtext + tree_to_html(childnode)
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
  def bbcode_to_html
    return BbParser.bb_to_html(self)
  end
end
