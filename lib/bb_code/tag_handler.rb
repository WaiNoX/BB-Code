require 'cgi'
require 'uri'

#der einfachste Parser, der den tagnamen nimmt und direkt in einen gleichnamigen html-tag umwandelt
class SimpleTag
  def self.parse_to_html(tag, childtext)
    out = '<' + tag.name + '>' + childtext + '</' + tag.name + '>'
    return out
  end
end

#der parser für fehlerhafte tags zeigt den original tag an
class FailTag
  def self.parse_to_html(tag, childtext)
    return CGI.escapeHTML(tag.original) + childtext + '[/' + tag.name + ']'
  end
end

#parser für dem mail-tag
class MailTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil?) # childtext ist emailadresse
      return '<a href=mailto:"' + URI.escape(childtext) + '">' + CGI.escapeHTML(childtext) + '</a>'
    else # tag hat die email als parameter
      return '<a href=mailto:"' + URI.escape(tag.get_data) + '">' + CGI.escapeHTML(childtext) + '</a>'
    end
  end
end

#parser für den Color-Tag
class ColorTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil? ) # eingabefehler, dieser tag erwartet einen parameter
      return FailTag.parse_to_html(tag, childtext)
    elsif(tag.get_data=~/\A([a-z]+|[0-9a-f]{6})\z/i) #der parameter muss eine farbe sein
      return '<font color="'+ tag.get_data() +'>'+ childtext + '</font>'
    else #eingabefehler: parameter war keine farbe, gib das original aus
      eturn FailTag.parse_to_html(tag, childtext)
    end
  end
end

#parser für den font-tag
class FontTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil? ) # eingabefehler, dieser tag erwartet einen parameter
      return FailTag.parse_to_html(tag, childtext)
    elsif(tag.get_data=~/\A[a-z]+\z/i) #der parameter muss eine schriftart sein
      return '<font face="'+ tag.get_data() +'>'+ childtext + '</font>'
    else #eingabefehler: parameter war keine schriftart, gib das original aus
      return FailTag.parse_to_html(tag, childtext)
    end
  end
end

#parser für den align-tag
class AlignTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil? ) # eingabefehler, dieser tag erwartet einen parameter
      return FailTag.parse_to_html(tag, childtext)
    elsif(tag.get_data=~/\A(center|left|right|justify)\z/i) #der parameter muss eine ausrichtig sein 
      return '<div style="text-align:'+ tag.get_data() +';">'+ childtext + '</font>'
    else #eingabefehler: parameter war keine schriftart, gib das original aus
      return FailTag.parse_to_html(tag, childtext)
    end
  end
end

#parser für den quote-tag
class QuoteTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil? ) # quote ohne zitierten
      return '<fieldset><blockquote>'+childtext+'</blockquote></fieldset>'
    else #quote mit zitiertem 
      return '<fieldset><legend>'+CGI.escapeHTML(tag.get_data)+'</legend><blockquote>'+childtext+'</blockquote></fieldset>'
    end
  end
end

#parser für den img-tag
class ImgTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil? ) #originalgröße
      return '<img src="'+URI.escape(childtext)+'" alt="'+CGI.escapeHTML(childtext)+'"/>'
    elsif(tag.get_data=~/\A[0-9]+x[0-9]+\z/i) # größenangabe in pixeln
      data = tag.get_data.match(/\A([0-9]+)x([0-9]+)\z/)
      width = data[1]
      height = data[2]
      '<img src="'+URI.escape(childtext)+'" width="'+width+'" height="'+height+'" alt="'+CGI.escapeHTML(childtext)+'">'
    elsif(tag.get_data=~/\A[0-9]+%\z/) # größenangabe in prozent
      '<img src="'+URI.escape(childtext)+'" width="'+tag.get_data() +'" height="'+ tag.get_data() +'" alt="'+CGI.escapeHTML(childtext)+'">'
    end
  end
end

#parser für dem url-tag
class UrlTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil?) # childtext ist url
      return '<a href="' + URI.escape(childtext) + '">' + CGI.escapeHTML(childtext) + '</a>'
    else # tag hat die url als parameter
      return '<a href="' + URI.escape(tag.get_data()) + '">' + CGI.escapeHTML(childtext) + '</a>'
    end
  end
end


#parser für dem list-tag
class ListTag
  def self.parse_to_html(tag, childtext)
    if(tag.get_data.nil?) #ungeordnete liste
      return '<ul>' + childtext + '</ul>'
    elsif(tag.get_data() == '1') #geordnete liste
      return '<ol>' + childtext + '</ol>'
    else # aufzählungstyp wird nicht unterstützt, zeige geordnete liste an # das könnte man eventuell erweitern
      return '<ol>' + childtext + '</ol>'
    end
  end
end

class TableTag
  def self.parse_to_html(tag, childtext)
    return '<table border="1">' + childtext + '</table>'
  end
end