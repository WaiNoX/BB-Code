require 'bb_parser/tag_types'

describe 'TagTypes' do


  it "should give info by symbol" do
    info = TagTypes.get_info :b
    info.nil?.should be_false
    info = TagTypes.get_info :äöü
    info.nil?.should be_true
  end
  
  it 'should have all attributes for known tags' do
    types = [:name, :allows_all_tags, :allowed_tags, :allowed_in_all, :allowed_in, :handler]
    tags_all = [:b, :i, :u, :s, :sub, :sup, :mail, :color, :font, :align, :quote, :img, :url, :list, :li, :table, :tr, :td, :th, :size]
    tags_all.each { |symbol| 
      info = TagTypes.get_info(symbol)
      info.nil?.should be_false
      types.each { |type| 
        info[type].nil?.should be_false
      }
    }
  end
  
  it 'TagHandler should exist' do
    tags_all = [:b, :i, :u, :s, :sub, :sup, :mail, :color, :font, :align, :quote, :img, :url, :list, :li, :table, :tr, :td, :th, :size]
    tags_all.each { |symbol| 
      info = TagTypes.get_info(symbol)
      info.nil?.should be_false
      clazz = nil
      expect {clazz = Object.const_get(info[:handler])}.to_not raise_error
      clazz.nil?.should be_false
    }
  end
end

